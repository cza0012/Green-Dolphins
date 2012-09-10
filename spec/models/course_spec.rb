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
  before(:each) do
    @attr = { 
      :name => "ENGR Test"
    }
  end
  
  it "should create a new instance given a valid attribute" do
    Course.create!(@attr)
  end
end
