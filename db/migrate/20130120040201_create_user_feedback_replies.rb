class CreateUserFeedbackReplies < ActiveRecord::Migration
  def change
    create_table :user_feedback_replies do |t|
      t.integer :user_feedback_id
      t.integer :user_id
      t.text :content

      t.timestamps
    end
  end
end
