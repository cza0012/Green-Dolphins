class AddArchiveToComments < ActiveRecord::Migration
  def change
    add_column :comments, :deleted_comment, :boolean
  end
end
