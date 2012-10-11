class ChangeAnonymonsQuestion < ActiveRecord::Migration
  def change
    remove_column :questions, :anonymous
    add_column :questions, :anonymous, :boolean
  end
end
