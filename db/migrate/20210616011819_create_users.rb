class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :firebase_uid
      t.string :email
      t.string :display_name
      t.string :photo_url

      t.timestamps
    end
    add_index :users, :firebase_uid, unique: true
    add_index :users, :email, unique: true
  end
end
