class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.string  :name, null: false
      t.text    :description
      t.boolean :completed, null: false, default: false
      t.boolean :deleted, null: false, default: false
      t.integer :user_id, null: false
      t.timestamps
    end
    add_index :tasks, :user_id
  end
end
