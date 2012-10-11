class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :sender_id
      t.text :content
      t.boolean :read

      t.timestamps
    end
  end
end
