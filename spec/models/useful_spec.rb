# == Schema Information
#
# Table name: usefuls
#
#  id              :integer          not null, primary key
#  usefulable_id   :integer
#  usefulable_type :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe Useful do
  let(:question) { FactoryGirl.create(:question) }
  before(:each) do    
      @attr = { 
        :usefulable_type => "question"
      }
                             
      @useful = question.usefuls.build(@attr) 
    end
    
    subject { @useful}
       
    it { should respond_to(:usefulable_type)}
    it { @useful.usefulable_type.should == question.class.name.downcase}
    
    it "should create a new instance given a valid attribute" do
       Useful.create!()
     end
end
