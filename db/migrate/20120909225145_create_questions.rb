class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title
      t.text :content
      t.text :code
      t.text :error
      t.integer :anonymous

      t.timestamps
    end
  end
end
