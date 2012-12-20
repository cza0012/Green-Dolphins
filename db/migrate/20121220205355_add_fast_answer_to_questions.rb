class AddFastAnswerToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :fast_answer, :boolean
  end
end
