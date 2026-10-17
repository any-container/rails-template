class CreateIdentities < ActiveRecord::Migration[8.1]
  def change
    create_table :identities do |t|
      t.string :given_name
      t.string :surname, null: false
      t.string :email, null: false
      t.string :user_name, null: false

      t.timestamps
    end

    add_index :identities, :email, unique: true
    add_index :identities, :user_name, unique: true
  end
end
