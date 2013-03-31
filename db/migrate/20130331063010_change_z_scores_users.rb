class ChangeZScoresUsers < ActiveRecord::Migration
  def change
    remove_column :users, :z_scores
    add_column :users, :z_scores, :'double precision'
  end
end
