# == Schema Information
#
# Table name: courses
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Course do
  let(:user){ FactoryGirl.create(:user) }
  before(:each) do
    @attr = { 
      :name => "ENGR Test"
    }
    @course = user.courses.build(@attr)
  end
  
  subject{ @course }
  
  it{ should be_valid(:name) }
  
  it "should create a new instance given a valid attribute" do
    expect{ user.courses.create!(@attr) }.to change{ Course.count }.by(1) 
  end
  
  it "should be got by its questions" do
      user.courses.create!(@attr)
      user.should have(3).courses
  end
  
end
