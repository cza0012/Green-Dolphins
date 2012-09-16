class AddUserIdToUseful < ActiveRecord::Migration
  def change
    add_column :feedback, :created_at :datetime  
    add_column :feedback, :created_at :datetime  
  end
end
