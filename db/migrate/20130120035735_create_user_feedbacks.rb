class CreateUserFeedbacks < ActiveRecord::Migration
  def change
    create_table :user_feedbacks do |t|
      t.string :title
      t.text :content
      t.string :type
      t.integer :user_id

      t.timestamps
    end
  end
end
