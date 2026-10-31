require "rails_helper"

RSpec.describe RomContainer do
  it "registers every relation in app/relations" do
    expect(described_class.instance.relations.elements.keys).to contain_exactly(:users, :accounts)
  end

  it "keeps its migration versions apart from Active Record's schema_migrations" do
    db = described_class.gateway.connection

    expect(db[:rom_schema_migrations].select_map(:filename)).to eq(%w[20261031000001_create_users.rb 20261031000002_create_accounts.rb])
    expect(described_class).not_to be_pending
  end

  it "stores ids as uuid and timestamps as timestamptz" do
    db = described_class.gateway.connection

    %i[users accounts].each do |table|
      types = db.schema(table).to_h { |name, info| [name, info[:db_type]] }
      expect(types.slice(:id, :created_at, :updated_at).values).to eq(["uuid", "timestamp with time zone", "timestamp with time zone"])
    end
  end
end
