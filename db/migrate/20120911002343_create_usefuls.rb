class CreateUsefuls < ActiveRecord::Migration
  def change
    create_table :usefuls do |t|
      t.references :usefulable, :polymorphic => true
      t.timestamps
    end
  end
end
