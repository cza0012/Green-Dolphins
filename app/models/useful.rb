# == Schema Information
#
# Table name: usefuls
#
#  id              :integer          not null, primary key
#  usefulable_id   :integer
#  usefulable_type :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Useful < ActiveRecord::Base
  attr_accessible :usefulable_type
  belongs_to :usefulable, :polymorphic => true
end
