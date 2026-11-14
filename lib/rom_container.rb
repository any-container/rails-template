require "uri"

# Builds the ROM container from the Rails primary database config.
#
# Every class in app/relations is registered. Repos take the container:
# UserRepo.new(RomContainer.instance).
module RomContainer
  # Active Record owns "schema_migrations", so ROM keeps its own table.
  MIGRATIONS_TABLE = :rom_schema_migrations
  MIGRATIONS_PATH = "db/rom/migrate".freeze

  class << self
    def instance
      @instance ||= build
    end

    def reset!
      @instance&.gateways&.each_value { |gateway| gateway.connection.disconnect }
      @instance = nil
    end

    def configuration
      @configuration ||= ROM::Configuration.new(:sql, url, migrator: {path: Rails.root.join(MIGRATIONS_PATH)}).tap do |config|
        config.register_relation(*relations)
      end
    end

    def gateway
      configuration.gateways.fetch(:default)
    end

    def migrate(target: nil)
      options = {table: MIGRATIONS_TABLE}
      options[:target] = target if target
      ROM::SQL.with_gateway(gateway) { gateway.migrator.run(options) }
    end

    def pending?
      ROM::SQL.with_gateway(gateway) do
        !Sequel::Migrator.is_current?(gateway.connection, Rails.root.join(MIGRATIONS_PATH).to_s, table: MIGRATIONS_TABLE)
      end
    end

    private

    def build
      ROM.container(configuration)
    end

    def relations
      Rails.root.glob("app/relations/*.rb").sort.map do |path|
        File.basename(path, ".rb").camelize.constantize
      end
    end

    def url
      db = ActiveRecord::Base.configurations.configs_for(env_name: Rails.env.to_s, name: "primary").configuration_hash
      userinfo = [db[:username], db[:password]].compact.map { |v| URI.encode_www_form_component(v) }.join(":")
      host = [db[:host] || "localhost", db[:port]].compact.join(":")
      "postgres://#{"#{userinfo}@" unless userinfo.empty?}#{host}/#{db[:database]}"
    end
  end
end
