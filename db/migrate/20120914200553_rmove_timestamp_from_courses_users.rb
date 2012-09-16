class RmoveTimestampFromCoursesUsers < ActiveRecord::Migration
  def change
    remove_column :courses_users, :created_at
    remove_column :courses_users, :updated_at
  end
end
