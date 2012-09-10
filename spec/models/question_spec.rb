# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  content    :text
#  code       :text
#  error      :text
#  anonymous  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Question do
  before(:each) do
    @attr = { 
      :title => "What is Ruby on Rails?",
      :content => "I did not know what is Ruby on Rails",
      :code => "<pre></pre>",
      :error => "No error",
      :anonymous => 1
    }
  end
  
  it "should create a new instance given a valid attribute" do
    Question.create!(@attr)
  end
end
