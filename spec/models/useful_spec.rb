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

require 'spec_helper'

describe Useful do
  let(:user) { FactoryGirl.create(:user) }
  let(:question) { FactoryGirl.create(:question) }
  before(:each) do    
      @attr = { 
        :user_id => user.id
      }
                             
      @useful = question.usefuls.build(@attr) 
    end
    
    subject { @useful}
       
    it { should respond_to(:usefulable_type) }
    it { should respond_to(:user_id) }
    it { @useful.usefulable_type.should == question.class.name }
    it { @useful.usefulable_id.should == question.id }
    
    it "should create a new instance given a valid attribute" do
       question.usefuls.create!(@attr)
       User.find(user.id).usefuls.size.should == 1
       question.usefuls.size.should == 2
     end
end
