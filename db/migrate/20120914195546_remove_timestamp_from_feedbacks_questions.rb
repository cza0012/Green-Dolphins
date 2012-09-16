class RemoveTimestampFromFeedbacksQuestions < ActiveRecord::Migration
  def change
    remove_column :feedbacks_questions, :created_at
    remove_column :feedbacks_questions, :updated_at
  end
end
