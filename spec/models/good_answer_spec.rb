# == Schema Information
#
# Table name: good_answers
#
#  id          :integer          not null, primary key
#  question_id :integer
#  comment_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe GoodAnswer do
  let(:question) { FactoryGirl.create(:question) }
  let(:comment) { FactoryGirl.create(:comment, question_id: 1, user_id: 1)}
  before(:each) do    
      @comment_attr = { 
        :comment_id => comment.id
      }
      @question_attr = {
        :question_id => question.id
      }                       
      @goodAnswer = question.build_good_answer(@comment_attr) 
  end
  subject { @goodAnswer }
     
  it { should respond_to(:question_id) }
  it { should respond_to(:comment_id) }
  
  it "should create a new instance given a valid attribute by a question" do
     expect { question.create_good_answer(@comment_attr) }.to change{ GoodAnswer.count }.by(1)
  end
  it "should create a new instance given a valid attribute by a comment" do
     expect { comment.create_good_answer(@question_attr) }.to change{ GoodAnswer.count }.by(1)
  end
  it "should be got by its question" do
       @testGoodAnswer = question.good_answer
       @testGoodAnswer.question_id.should == question.id
       @testGoodAnswer.comment_id.should == comment.id
  end
end
