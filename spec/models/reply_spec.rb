# == Schema Information
#
# Table name: replies
#
#  id         :integer          not null, primary key
#  content    :text
#  user_id    :integer
#  comment_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Reply do
  let(:user) { FactoryGirl.create(:user) }
  let(:comment) { FactoryGirl.create(:comment, user_id: '1', question_id: '1') }
  before(:each) do
    @attr = { 
      :content  => "Good job",
      :comment_id => comment.id
    }
    @reply = user.replies.create!(@attr)
  end
  
  subject { @reply }
  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:comment_id) }
end
