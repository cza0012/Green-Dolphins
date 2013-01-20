class AddTypeFeedbackToUserFeedbacks < ActiveRecord::Migration
  def change
    remove_column :user_feedbacks, :type
    add_column :user_feedbacks, :type_feedback, :string
  end
end
