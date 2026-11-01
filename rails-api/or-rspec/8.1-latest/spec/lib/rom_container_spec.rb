require "rails_helper"

RSpec.describe RomContainer do
  let(:db) { described_class.gateway.connection }
  let(:app_tables) { %i[users accounts] }

  def table_exists?(name)
    db.table_exists?(name)
  end

  describe ".instance" do
    it "returns a ROM container" do
      expect(described_class.instance).to be_a(ROM::Container)
    end

    it "returns the same container on every call" do
      expect(described_class.instance).to equal(described_class.instance)
    end

    it "registers every relation in app/relations" do
      expect(described_class.instance.relations.elements.keys).to contain_exactly(:users, :accounts)
    end
  end

  describe ".reset!" do
    # Later specs share the Factory built on the original container.
    around do |example|
      original = described_class.instance
      example.run
    ensure
      described_class.instance_variable_set(:@instance, original)
    end

    it "makes the next .instance call build a new container" do
      before = described_class.instance

      described_class.reset!

      expect(described_class.instance).not_to equal(before)
    end

    it "leaves the database usable" do
      described_class.reset!

      expect(described_class.instance.relations[:users].count).to eq(0)
    end
  end

  describe ".configuration" do
    it "returns a ROM configuration" do
      expect(described_class.configuration).to be_a(ROM::Configuration)
    end

    it "returns the same configuration on every call" do
      expect(described_class.configuration).to equal(described_class.configuration)
    end

    it "registers the relations in app/relations" do
      expect(described_class.configuration.relation_classes).to contain_exactly(Users, Accounts)
    end
  end

  describe ".gateway" do
    it "returns the default SQL gateway of the configuration" do
      expect(described_class.gateway).to be_a(ROM::SQL::Gateway)
      expect(described_class.gateway).to equal(described_class.configuration.gateways.fetch(:default))
    end

    it "connects to the Rails primary database" do
      rails_database = ActiveRecord::Base.configurations
        .configs_for(env_name: Rails.env.to_s, name: "primary").configuration_hash[:database]

      expect(db.opts[:database]).to eq(rails_database)
    end

    it "reads migrations from db/rom/migrate" do
      expect(described_class.gateway.migrator.path).to eq(Rails.root.join("db/rom/migrate"))
    end
  end

  describe ".migrate" do
    it "creates the app tables" do
      described_class.migrate(target: 0)

      described_class.migrate

      expect(app_tables).to all(satisfy { |table| table_exists?(table) })
    end

    it "records the applied migrations in rom_schema_migrations, not schema_migrations" do
      expect(db[:rom_schema_migrations].select_map(:filename))
        .to eq(%w[20261031000001_create_users.rb 20261031000002_create_accounts.rb])
    end

    it "can be run again with nothing to do" do
      expect { described_class.migrate }.not_to change { db[:rom_schema_migrations].count }
    end

    it "migrates down to the given version" do
      described_class.migrate(target: 20261031000001)

      expect(table_exists?(:users)).to be(true)
      expect(table_exists?(:accounts)).to be(false)
    end

    it "reverts everything with target 0" do
      described_class.migrate(target: 0)

      expect(app_tables).to all(satisfy { |table| !table_exists?(table) })
      expect(db[:rom_schema_migrations].count).to eq(0)
    end
  end

  describe ".pending?" do
    it "is false when every migration has run" do
      expect(described_class).not_to be_pending
    end

    it "is true when a migration has not run" do
      described_class.migrate(target: 20261031000001)

      expect(described_class).to be_pending
    end
  end
end
