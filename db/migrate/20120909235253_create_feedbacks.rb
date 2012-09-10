class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :name
      t.text :detail
      t.string :photo_link

      t.timestamps
    end
  end
end
