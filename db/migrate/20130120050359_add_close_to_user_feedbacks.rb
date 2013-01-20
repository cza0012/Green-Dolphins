class AddCloseToUserFeedbacks < ActiveRecord::Migration
  def change
    add_column :user_feedbacks, :close, :boolean
  end
end
