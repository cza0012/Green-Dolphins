class AddUsersAcademicOpperties < ActiveRecord::Migration
  def change
    add_column :users, :school, :string
    add_column :users, :sex, :integer
    add_column :users, :level, :integer
  end
end
