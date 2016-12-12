class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.timestamps
      t.string     :full_name, null: false
      t.string     :password_digest, null: false
      t.string     :token, null: false
      t.text       :description
      t.string     :email, null: false
      t.string     :fname
      t.string     :lname
    end
    add_index :users, :email
    add_index :users, :token, unique: true
  end
end
