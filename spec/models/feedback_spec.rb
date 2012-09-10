# == Schema Information
#
# Table name: feedbacks
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  detail     :text
#  photo_link :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Feedback do
  before(:each) do
    @attr = { 
      :name => "Good test",
      :detail => "Users has a good test.",
      :photo_link => "www.google.com"
    }
  end
  
  it "should create a new instance given a valid attribute" do
    Feedback.create!(@attr)
  end
end
