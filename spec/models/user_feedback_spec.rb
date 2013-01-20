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

require 'spec_helper'

describe UserFeedback do
  pending "add some examples to (or delete) #{__FILE__}"
end
