class ChangeUsers < ActiveRecord::Migration
  def change
    remove_column :users, :sex 
    add_column :users, :sex, :string
    remove_column :users, :level 
    add_column :users, :level, :string
  end
end
