class ChangeAnonymonsComments < ActiveRecord::Migration
  def change
    remove_column :comments, :anonymous
    add_column :comments, :anonymous, :boolean
  end
end
