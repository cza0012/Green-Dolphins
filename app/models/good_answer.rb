# == Schema Information
#
# Table name: good_answers
#
#  id          :integer          not null, primary key
#  question_id :integer
#  comment_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class GoodAnswer < ActiveRecord::Base
  attr_accessible :question_id, :comment_id
  validates_uniqueness_of :question_id, :comment_id
  belongs_to :question
  belongs_to :comment 
end
