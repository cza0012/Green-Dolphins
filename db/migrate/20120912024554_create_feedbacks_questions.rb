class CreateFeedbacksQuestions < ActiveRecord::Migration
  def change
    create_table :feedbacks_questions do |t|
      t.integer :feedback_id
      t.integer :question_id

      t.timestamps
    end
  end
end
