class AddArchiveToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :deleted_question, :boolean
  end
end
