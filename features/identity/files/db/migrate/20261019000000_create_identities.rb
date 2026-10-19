class CreateIdentities < ActiveRecord::Migration[8.1]
  def change
    create_table :identities do |t|
      t.string :given_name
      t.string :surname, null: false
      t.string :user_email, null: false
      t.string :normalized_email, null: false
      t.string :user_name, null: false
      t.string :password_digest, null: false

      t.timestamps
    end

    add_index :identities, :user_email, unique: true
    add_index :identities, :normalized_email, unique: true
    add_index :identities, "lower(user_name)", unique: true, name: "index_identities_on_lower_user_name"
  end
end
