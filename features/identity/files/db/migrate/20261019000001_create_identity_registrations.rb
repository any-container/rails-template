class CreateIdentityRegistrations < ActiveRecord::Migration[8.1]
  def change
    create_table :identity_registrations do |t|
      t.string :given_name
      t.string :surname, null: false
      t.string :user_email, null: false
      t.string :normalized_email, null: false
      t.string :user_name, null: false
      t.string :password_digest, null: false
      t.string :confirmation_digest, null: false
      t.datetime :expires_at, null: false
      t.datetime :confirmed_at

      t.timestamps
    end

    add_index :identity_registrations, :confirmation_digest, unique: true
    add_index :identity_registrations, :normalized_email
  end
end
