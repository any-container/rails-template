ROM::SQL.migration do
  change do
    create_table :accounts do
      column :id, :uuid, null: false, default: Sequel.function(:gen_random_uuid), primary_key: true
      column :name, String, null: false
      foreign_key :owner_id, :users, type: :uuid, null: false, on_delete: :restrict, index: true
      column :created_at, :timestamptz, null: false, default: Sequel::CURRENT_TIMESTAMP
      column :updated_at, :timestamptz, null: false, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
