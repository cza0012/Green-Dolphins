class AddPointsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :points, :integer
    add_column :users, :z_scores, :integer
  end
end
