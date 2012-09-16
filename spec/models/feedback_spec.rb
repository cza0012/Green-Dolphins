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
  let(:question) { FactoryGirl.create(:question) }
  before(:each) do
        @attr = { 
          :name => "Good test",
          :detail => "Users has a good test.",
          :photo_link => "www.google.com"
        }
        @feedback = question.feedbacks.build(@attr)
  end
    
  subject { @feedback }
  it { should respond_to(:name) }
  it { should respond_to(:detail) }
  it { should respond_to(:photo_link) }
          
  it "should create a new instance given a valid attribute" do
      expect { question.feedbacks.create!(@attr) }.to change{ Feedback.count }.by (1)
  end
  
  it "should be got by its questions" do
      question.feedbacks.create!(@attr)
      question.should have(3).feedbacks
  end
  
end
