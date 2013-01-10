# == Schema Information
#
# Table name: notifications
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  content       :text
#  read          :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  sendable_id   :integer
#  sendable_type :string(255)
#

require 'spec_helper'

describe Notification do
  let(:sender) { FactoryGirl.create(:user) }
  let(:question) { FactoryGirl.create(:question, user_id: sender.id) }
  before(:each) do    
      @attr = { 
        :user_id => sender.id,
        :content => "Please help me",
        :read => false,
      }
      @notification = question.notifications.build(@attr) 
  end
  subject { @notification }

   it { should respond_to(:content) }
   it { should respond_to(:read) }
   it { should respond_to(:user_id) }
   it { @notification.user_id.should == sender.id }
   it { @notification.sendable_id.should == question.id }
   it { @notification.sendable_type == 'Question' }
   
   it "should create an new instance." do
     expect{question.notifications.create!(@attr)}.to change{Notification.count}.by (1)
   end
   
   it "should create an new instance." do
     expect{sender.notifications.create!(@attr)}.to change{Notification.count}.by (1)
   end
   
   context "was read." do

     before{
       @notification.read_notification
     }
    it{@notification.read.should == true} 
   end
end
