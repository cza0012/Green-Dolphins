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

require 'spec_helper'

describe UserFeedbackReply do
  pending "add some examples to (or delete) #{__FILE__}"
end
