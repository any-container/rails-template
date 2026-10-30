require "forwardable"
require "yaml"

# Feature registry. See features/feature_registry.md.
module Features
  MANIFEST = "0-manifest.yml".freeze
  TRUE_VALUES = %w[true 1 yes on].freeze

  class Invalid < StandardError; end

  Definition = Struct.new(:name, :always_on, :depends_on, :gems, keyword_init: true)

  class Registry
    def initialize(dir:, env: ENV)
      @dir = Pathname(dir)
      @env = env
    end

    def env_key(name) = "FEATURE_#{name.to_s.upcase}"

    # Sets each manifest entry in ENV unless the environment already defines it.
    def load_env!
      manifest.each { |key, value| @env[key] = value.to_s unless @env.key?(key) }
    end

    def names = definitions.keys

    def built?(name) = definitions.key?(name.to_sym)

    def toggled?(name)
      definition = fetch(name)
      definition.always_on || TRUE_VALUES.include?(@env[env_key(name)].to_s.downcase)
    end

    def enabled?(name, visited = [])
      definition = fetch(name)
      return false if visited.include?(definition.name)

      toggled?(name) && definition.depends_on.all? { |dep| enabled?(dep, visited + [definition.name]) }
    end

    def gems = definitions.values.flat_map(&:gems).uniq

    def validate!
      errors = []
      keys = manifest.keys
      names.each { |name| errors << "#{name}: no #{env_key(name)} in #{MANIFEST}" unless keys.include?(env_key(name)) }
      keys.each { |key| errors << "#{key}: no description file in features/" unless names.any? { |name| env_key(name) == key } }
      definitions.each_value do |definition|
        definition.depends_on.each do |dep|
          errors << "#{definition.name}: unknown dependency #{dep}" unless built?(dep)
        end
      end
      errors.concat(cycles)
      if errors.empty?
        definitions.each_value do |definition|
          next unless toggled?(definition.name)

          definition.depends_on.reject { |dep| toggled?(dep) }.each do |dep|
            errors << "#{definition.name} is on but its dependency #{dep} is off"
          end
        end
      end
      raise Invalid, errors.join("\n") if errors.any?
      self
    end

    private

    def manifest
      path = @dir.join(MANIFEST)
      path.exist? ? (YAML.safe_load_file(path) || {}) : {}
    end

    def definitions
      @definitions ||= @dir.glob("*.md").reject { |path| path.basename.to_s == "README.md" }.sort.to_h do |path|
        name = path.basename(".md").to_s.to_sym
        [name, parse(name, path)]
      end
    end

    def parse(name, path)
      match = path.read.match(/\A---\n(.*?)^---\n/m) or raise Invalid, "#{path.basename}: missing front matter"
      meta = YAML.safe_load(match[1]) || {}
      Definition.new(
        name: name,
        always_on: meta.fetch("always_on", false),
        depends_on: Array(meta["depends_on"]).map(&:to_sym),
        gems: Array(meta["gems"]).map { |gem| gem.is_a?(Hash) ? gem : { "name" => gem } }
      )
    end

    def fetch(name) = definitions.fetch(name.to_sym) { raise Invalid, "unknown feature #{name}" }

    def cycles
      definitions.keys.filter_map do |start|
        "#{start}: dependency cycle" if reaches?(start, start, [])
      end
    end

    def reaches?(from, target, seen)
      definitions.fetch(from).depends_on.any? do |dep|
        next false unless definitions.key?(dep)
        next true if dep == target
        next false if seen.include?(dep)

        reaches?(dep, target, seen + [dep])
      end
    end
  end

  class << self
    extend Forwardable

    def_delegators :registry, :load_env!, :validate!, :enabled?, :toggled?, :built?, :names, :gems, :env_key

    def registry = @registry ||= Registry.new(dir: Rails.root.join("features"))
  end
end
