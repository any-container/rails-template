ROM::SQL.migration do
  change do
    create_table :users do
      column :id, :uuid, null: false, default: Sequel.function(:gen_random_uuid), primary_key: true
      column :first_name, String, null: false
      column :last_name, String, null: false
      column :email, String, null: false
      column :created_at, :timestamptz, null: false, default: Sequel::CURRENT_TIMESTAMP
      column :updated_at, :timestamptz, null: false, default: Sequel::CURRENT_TIMESTAMP

      index Sequel.function(:lower, :email), unique: true, name: :users_email_lower_index
    end
  end
end
