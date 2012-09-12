class AddUserIdToUseful < ActiveRecord::Migration
  def change
    add_column :usefuls, :user_id, :integer
  end
end
