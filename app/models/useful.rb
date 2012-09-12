# == Schema Information
#
# Table name: usefuls
#
#  id              :integer          not null, primary key
#  usefulable_id   :integer
#  usefulable_type :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :integer
#

class Useful < ActiveRecord::Base
  attr_accessible :usefulable_type, :user_id
  
  validates :user_id, presence: true
  
  belongs_to :usefulable, :polymorphic => true
  belongs_to :user, :inverse_of => :usefuls
end
