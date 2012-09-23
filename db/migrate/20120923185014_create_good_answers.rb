class CreateGoodAnswers < ActiveRecord::Migration
  def change
    create_table :good_answers do |t|
      t.integer :question_id
      t.integer :comment_id

      t.timestamps
    end
  end
end
