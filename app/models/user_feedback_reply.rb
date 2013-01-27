# == Schema Information
#
# Table name: user_feedback_replies
#
#  id               :integer          not null, primary key
#  user_feedback_id :integer
#  user_id          :integer
#  content          :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class UserFeedbackReply < ActiveRecord::Base
  attr_accessible :content, :user_feedback_id, :user_id
  belongs_to :user_feedbacks, :inverse_of => :user_feedback_replies
  belongs_to :user, :inverse_of => :user_feedback_replies
end
