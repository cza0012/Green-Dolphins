class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.integer :line
      t.text :code
      t.integer :anonymous

      t.timestamps
    end
  end
end
