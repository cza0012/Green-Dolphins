class AddSendableToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :sendable_id, :integer
    add_column :notifications, :sendable_type, :string
    remove_column :notifications, :sender_id
  end
end
