# == Schema Information
#
# Table name: user_feedbacks
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  content       :text
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  close         :boolean
#  type_feedback :string(255)
#

class UserFeedback < ActiveRecord::Base
  attr_accessible :content, :title, :type_feedback, :user_id, :close
  validates :content, :title, :type_feedback, presence: true
  belongs_to :user, :inverse_of => :user_feedbacks
  has_many :user_feedback_replies, :inverse_of => :user_feedbacks
  self.per_page = 25
end
