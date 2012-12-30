# == Schema Information
#
# Table name: comments
#
#  id              :integer          not null, primary key
#  content         :text
#  line            :integer
#  code            :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :integer
#  question_id     :integer
#  anonymous       :boolean
#  hidden          :boolean
#  deleted_comment :boolean
#

require 'spec_helper'
Delayed::Worker.delay_jobs = false

describe Comment do
  let(:user) { FactoryGirl.create(:user) }
  let(:question) { FactoryGirl.create(:question) }
  before(:each) do
    @attr = { 
      :content  => "Good job",
      :line  => 9,
      :code => "<b>hi</b>",
      :anonymous => false,
      :question_id => question.id,
      :hidden => true
    }
    @comment = user.comments.create!(@attr)
  end
  
  subject { @comment }
  it { should respond_to(:content) }
  it { should respond_to(:line) }
  it { should respond_to(:code) }
  it { should respond_to(:anonymous) }
  it { should respond_to(:question_id) }
  
  it "should create a new instance given a valid attribute" do
    expect { user.comments.create!(@attr) }.to change{ Comment.count }.by(1) 
  end
  
  it "should be got by its comments" do
      user.comments.create!(@attr)
      Question.find( question.id ).should have(2).comments
      user.should have(2).comments
  end
  
  it "should be got by its comments" do
      user.comments.create!(@attr)
      Question.find( question.id ).should have(2).comments
      user.should have(2).comments
  end
  
  it "should be got by its comments" do
      user.add_role :ta
      comment = user.comments.create!(@attr)
      question = Question.find(comment.question_id)
      limitedTime = question.created_at + 1.hours
      waitingTime = limitedTime - DateTime.current()
      comment.hidden.should == false
  end
end
