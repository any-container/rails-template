require "rails_helper"
require "tmpdir"

RSpec.describe Features do
  def build(manifest:, features:, env: {})
    dir = Pathname(Dir.mktmpdir)
    dir.join(Features::MANIFEST).write(manifest.to_yaml)
    features.each do |name, meta|
      front = meta.empty? ? "" : meta.transform_keys(&:to_s).to_yaml.delete_prefix("---\n")
      dir.join("#{name}.md").write("---\n#{front}---\n# #{name}\n")
    end
    Features::Registry.new(dir: dir, env: env)
  end

  let(:features) do
    {
      base: { always_on: true },
      extra: { depends_on: ["base"], gems: [{ "name" => "rotp", "version" => "~> 6.3" }] }
    }
  end
  let(:manifest) { { "FEATURE_BASE" => "true", "FEATURE_EXTRA" => "false" } }

  describe "Registry#load_env!" do
    it "sets manifest values in ENV and keeps values already set" do
      env = { "FEATURE_EXTRA" => "true" }
      build(manifest: manifest, features: features, env: env).load_env!
      expect(env).to eq("FEATURE_BASE" => "true", "FEATURE_EXTRA" => "true")
    end
  end

  describe "Registry#enabled?" do
    it "follows ENV" do
      registry = build(manifest: manifest, features: features, env: { "FEATURE_EXTRA" => "on" })
      expect(registry.enabled?(:extra)).to be true
    end

    it "is false when toggled off" do
      expect(build(manifest: manifest, features: features, env: { "FEATURE_EXTRA" => "false" }).enabled?(:extra)).to be false
    end

    it "is true for an always_on feature whatever its ENV value" do
      expect(build(manifest: manifest, features: features, env: { "FEATURE_BASE" => "false" }).enabled?(:base)).to be true
    end

    it "raises for an unknown feature" do
      expect { build(manifest: manifest, features: features).enabled?(:nope) }.to raise_error(Features::Invalid)
    end
  end

  describe "Registry#gems" do
    it "lists the gems of every built feature" do
      expect(build(manifest: manifest, features: features).gems).to eq([{ "name" => "rotp", "version" => "~> 6.3" }])
    end
  end

  describe "Registry#validate!" do
    it "passes for a consistent set" do
      expect { build(manifest: manifest, features: features, env: {}).validate! }.not_to raise_error
    end

    it "fails when a feature has no manifest entry" do
      registry = build(manifest: { "FEATURE_BASE" => "true" }, features: features)
      expect { registry.validate! }.to raise_error(Features::Invalid, /FEATURE_EXTRA/)
    end

    it "fails when a manifest entry has no description" do
      registry = build(manifest: manifest.merge("FEATURE_GHOST" => "true"), features: features)
      expect { registry.validate! }.to raise_error(Features::Invalid, /FEATURE_GHOST/)
    end

    it "fails on an unknown dependency" do
      registry = build(manifest: manifest, features: features.merge(extra: { depends_on: ["ghost"] }))
      expect { registry.validate! }.to raise_error(Features::Invalid, /unknown dependency ghost/)
    end

    it "fails on a dependency cycle" do
      registry = build(
        manifest: { "FEATURE_A" => "false", "FEATURE_B" => "false" },
        features: { a: { depends_on: ["b"] }, b: { depends_on: ["a"] } }
      )
      expect { registry.validate! }.to raise_error(Features::Invalid, /cycle/)
    end

    it "fails when a feature is on and its dependency is off" do
      registry = build(
        manifest: { "FEATURE_A" => "true", "FEATURE_B" => "false" },
        features: { a: { depends_on: ["b"] }, b: {} },
        env: { "FEATURE_A" => "true", "FEATURE_B" => "false" }
      )
      expect { registry.validate! }.to raise_error(Features::Invalid, /dependency b is off/)
    end
  end

  describe "this app" do
    it "has a valid manifest" do
      expect { Features.validate! }.not_to raise_error
    end

    it "lists every feature gem in the Gemfile" do
      gemfile = Rails.root.join("Gemfile").read
      missing = Features.gems.map { |gem| gem["name"] }.reject { |name| gemfile.match?(/^\s*gem ["']#{Regexp.escape(name)}["']/) }
      expect(missing).to be_empty
    end
  end
end
