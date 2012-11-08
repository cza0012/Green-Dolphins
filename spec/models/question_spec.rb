# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  content    :text
#  code       :text
#  error      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  anonymous  :boolean
#

require 'spec_helper'

describe Question do
  let(:user) { FactoryGirl.create(:user) }
  before(:each) do    
      @attr = { 
        :title => "What is Ruby on Rails?",
        :content => "I did not know what is Ruby on Rails",
        :code => "```java\r\nimport java.util.ArrayList;\r\n\r\npublic class MainClass \
        {\r\n  public static void main(String args[]) {\r\n    List<CalendarOutput> \
          RecuringEve= Recurrent.eventView(component,begin,end);\r\n    \
          CalendarOutput caldavOutput = ListUtil.getReComponent(component, RecuringEve);\r\n\r\n  \
          System.out.print(\"Original contents of vals: \");\r\n    \
          for (int v : caldavOutput)\r\n      System.out.print(v + \" \");\r\n  }\r\n}\r\n```",
        :error => "No error",
        :anonymous => true
      }
      @question = user.questions.build(@attr) 
  end
  
  subject { @question }
  
  it { should respond_to(:title) }
  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { @question.user_id.should == user.id }
  
  it "should create a new instance given a valid attribute" do
    expect { user.questions.create!(@attr) }.to change{ Question.count }.by (1)
  end
  
  describe "when user_id is not present" do
      before { @question.user_id = nil}
      it {should_not be_valid}
  end
  
  it "should return 14 roles of a code" do
    @question.code_lines.should == 14
  end
  
end
