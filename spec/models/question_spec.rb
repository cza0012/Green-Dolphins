# == Schema Information
#
# Table name: questions
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  content     :text
#  code        :text
#  error       :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#  anonymous   :boolean
#  fast_answer :boolean
#

require 'spec_helper'
Delayed::Worker.delay_jobs = false

describe Question do
  let(:user) { FactoryGirl.create(:user) }
  let(:user1) { FactoryGirl.create(:user, email: 'test2@auburn.edu') }
  before(:each) do    
      @attr = { 
        :title => "What is Ruby on Rails?",
        :content => "I did not know what is Ruby on Rails",
        :code => "```java //Comments \r\nimport java.util.ArrayList;\r\n\r\npublic class MainClass \
        {\r\n  public static void main(String args[]) {\r\n    List<CalendarOutput> \
          RecuringEve= Recurrent.eventView(component,begin,end);\r\n    \
          CalendarOutput caldavOutput = ListUtil.getReComponent(component, RecuringEve);\r\n\r\n  \
          System.out.print(\"Original contents of vals: \");\r\n    \
          for (int v : caldavOutput)\r\n      System.out.print(v + \" \");\r\n  }\r\n}\r\n```",
        :error => "No error",
        :anonymous => true
      }
      
      @attr_feedback = { 
        :name => "Good test",
        :detail => "Users has a good test.",
        :photo_link => "www.google.com"
      }

      @question = user.questions.build(@attr) 
      @long_code = "A too long code"
      @huge_class = "Large class"
      @no_comment = "No comments in a code"
      @long_method = "Long method"
      @many_parameters = "Too many parameters"
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
  
  describe "Notification to ta" do
      before { 
        user.add_role :ta 
        user1.add_role :instructor
        @question.save
        @question.teacher_notification
      }
      it {
        @question.should have(2).notification
      }
  end
  
  it "should create a feedback for a question." do
    @question.save
    expect { @question.feedbacks << Feedback.find_or_create_by_name!(@attr_feedback) }.to change{ Feedback.count }.by (1)
    @question.should have(1).feedbacks
  end
  
  it "should use an exist feedback for a question." do
    @question.save
    question_code = user.questions.create!(@attr) 
    feedback = @question.feedbacks.create!(@attr_feedback)
    expect { question_code.feedbacks << Feedback.find_or_create_by_name!(@attr_feedback) }.not_to change{ Feedback.count }.by (1)
    question_code.should have(1).feedbacks
  end
  
  it "should have a long code and a big class feedback." do
    @attr = { 
      :title => "What is Ruby on Rails?",
      :content => "I did not know what is Ruby on Rails",
      :code => "```java\r\nimport java.util.ArrayList;\r\n\r\npublic class MainClass \
      {\r\n  public static void main(String args[]) {\r\n    List<CalendarOutput> \
        RecuringEve= Recurrent.eventView(component,begin,end);\r\n    \
        CalendarOutput caldavOutput = ListUtil.getReComponent(component, RecuringEve);\r\n\r\n  \
        System.out.print(\"Original contents of vals: \");\r\n    \
        for (int v : caldavOutput)\r\n      System.out.print(v + \" \");\r\n  }\r\n \ 
        public static void main(String args[]) {\r\n    List<CalendarOutput> \
        RecuringEve= Recurrent.eventView(component,begin,end);\r\n    \
        CalendarOutput caldavOutput = ListUtil.getReComponent(component, RecuringEve);\r\n\r\n  \
        System.out.print(\"Original contents of vals: \");\r\n    \
        for (int v : caldavOutput)\r\n      System.out.print(v + \" \");\r\n  }\r\n \
        public static void main(String args[]) {\r\n    List<CalendarOutput> \
        RecuringEve= Recurrent.eventView(component,begin,end);\r\n    \
        CalendarOutput caldavOutput = ListUtil.getReComponent(component, RecuringEve);\r\n\r\n  \
        System.out.print(\"Original contents of vals: \");\r\n    \
        for (int v : caldavOutput)\r\n      System.out.print(v + \" \");\r\n  }\r\n \
        public static void main(String args[]) {\r\n    List<CalendarOutput> \
        RecuringEve= Recurrent.eventView(component,begin,end);\r\n    \
        CalendarOutput caldavOutput = ListUtil.getReComponent(component, RecuringEve);\r\n\r\n  \
        System.out.print(\"Original contents of vals: \");\r\n    \
        for (int v : caldavOutput)\r\n      System.out.print(v + \" \");\r\n  }\r\n \ 
        public static void main(String args[]) {\r\n    List<CalendarOutput> \
        RecuringEve= Recurrent.eventView(component,begin,end);\r\n    \
        CalendarOutput caldavOutput = ListUtil.getReComponent(component, RecuringEve);\r\n\r\n  \
        System.out.print(\"Original contents of vals: \");\r\n    \
        for (int v : caldavOutput)\r\n      System.out.print(v + \" \");\r\n  }\r\n \
        public static void main(String args[]) {\r\n    List<CalendarOutput> \
        RecuringEve= Recurrent.eventView(component,begin,end);\r\n    \
        CalendarOutput caldavOutput = ListUtil.getReComponent(component, RecuringEve);\r\n\r\n  \
        System.out.print(\"Original contents of vals: \");\r\n    \
        for (int v : caldavOutput)\r\n      System.out.print(v + \" \");\r\n  }\r\n \
        public static void main(String args[]) {\r\n    List<CalendarOutput> \
        RecuringEve= Recurrent.eventView(component,begin,end);\r\n    \
        CalendarOutput caldavOutput = ListUtil.getReComponent(component, RecuringEve);\r\n\r\n  \
        System.out.print(\"Original contents of vals: \");\r\n    \
        for (int v : caldavOutput)\r\n      System.out.print(v + \" \");\r\n  }\r\n \
        public static void main(String args[]) {\r\n    List<CalendarOutput> \
        RecuringEve= Recurrent.eventView(component,begin,end);\r\n    \
        CalendarOutput caldavOutput = ListUtil.getReComponent(component, RecuringEve);\r\n\r\n  \
        System.out.print(\"Original contents of vals: \");\r\n    \
        for (int v : caldavOutput)\r\n      System.out.print(v + \" \");\r\n  }\r\n \
        public static void main(String args[]) {\r\n    List<CalendarOutput> \
        RecuringEve= Recurrent.eventView(component,begin,end);\r\n    \
        CalendarOutput caldavOutput = ListUtil.getReComponent(component, RecuringEve);\r\n\r\n  \
        System.out.print(\"Original contents of vals: \");\r\n    \
        for (int v : caldavOutput)\r\n      System.out.print(v + \" \");\r\n  }\r\n \
        public static void main(String args[]) {\r\n    List<CalendarOutput> \
        RecuringEve= Recurrent.eventView(component,begin,end);\r\n    \
        CalendarOutput caldavOutput = ListUtil.getReComponent(component, RecuringEve);\r\n\r\n  \
        System.out.print(\"Original contents of vals: \");\r\n    \
        for (int v : caldavOutput)\r\n      System.out.print(v + \" \");\r\n  }\r\n \
        }\r\n```",
      :error => "No error",
      :anonymous => true
    }
    question_code = user.questions.create!(@attr) 
    question_code.feedbacks.find_by_name(@long_code).should be_true
    question_code.feedbacks.find_by_name(@huge_class).should be_true
  end
  
  it "should have no comments in a code." do
    @attr = { 
      :title => "What is Ruby on Rails?",
      :content => "I did not know what is Ruby on Rails",
      :code => "```java \r\nimport java.util.ArrayList;\r\n\r\npublic class MainClass \
      {\r\n  public static void main(String args[]) {\r\n    List<CalendarOutput> \
        RecuringEve= Recurrent.eventView(component,begin,end);\r\n    \
        CalendarOutput caldavOutput = ListUtil.getReComponent(component, RecuringEve);\r\n\r\n  \
        System.out.print(\"Original contents of vals: \");\r\n    \
        for (int v : caldavOutput)\r\n      System.out.print(v + \" \");\r\n  }\r\n}\r\n```",
      :error => "No error",
      :anonymous => true
    }
    question_code = user.questions.create!(@attr) 
    question_code.should have(1).feedbacks
    question_code.feedbacks.find_by_name(@no_comment).should be_true
  end
  
  it "should detect // of a comment." do
    @attr = { 
      :title => "What is Ruby on Rails?",
      :content => "I did not know what is Ruby on Rails",
      :code => "```java\r\nimport java.util.ArrayList;\r\n\r\npublic class MainClass \
      {\r\n  public static void main(String args[]) {\r\n    List<CalendarOutput> \
        RecuringEve= Recurrent.eventView(component,begin,end);\r\n    \
        //CalendarOutput caldavOutput = ListUtil.getReComponent(component, RecuringEve);\r\n\r\n  \
        System.out.print(\"Original contents of vals: \");\r\n    \
        for (int v : caldavOutput)\r\n      System.out.print(v + \" \");\r\n  }\r\n}\r\n```",
      :error => "No error",
      :anonymous => true
    }
    
    question_code = user.questions.create!(@attr) 
    question_code.should have(0).feedbacks
    question_code.feedbacks.find_by_name(@no_comment).should be_false
  end
  
  it "should detect /* of a comment." do
    @attr = { 
      :title => "What is Ruby on Rails?",
      :content => "I did not know what is Ruby on Rails",
      :code => "```java\r\nimport java.util.ArrayList;\r\n\r\npublic class MainClass \
      {\r\n  public static void main(String args[]) {\r\n    List<CalendarOutput> \
        /*RecuringEve= Recurrent.eventView(component,begin,end);\r\n    \
        CalendarOutput caldavOutput = ListUtil.getReComponent(component, RecuringEve);*/\r\n\r\n  \
        System.out.print(\"Original contents of vals: \");\r\n    \
        for (int v : caldavOutput)\r\n      System.out.print(v + \" \");\r\n  }\r\n}\r\n```",
      :error => "No error",
      :anonymous => true
    }
    
    question_code = user.questions.create!(@attr) 
    question_code.should have(0).feedbacks
    question_code.feedbacks.find_by_name(@no_comment).should be_false
  end
  
  it "should detect a too long method." do
    @attr = { 
      :title => "What is Ruby on Rails?",
      :content => "I did not know what is Ruby on Rails",
      :code => "```java\r\nimport java.util.ArrayList;\r\n\r\npublic class MainClass \
      {\r\n  public static void main(String args[]) {\r\n \
        List<CalendarOutput> RecuringEve= Recurrent.eventView(component,begin,end);\r\n    \
        CalendarOutput caldavOutput = ListUtil.getReComponent(component, RecuringEve);*/\r\n\r\n  \
        System.out.print(\"Original contents of vals: \");\r\n    \
        for (int v : caldavOutput)\r\n      System.out.print(v + \" \");\r\n  }\r\n    \
        List<CalendarOutput> RecuringEve= Recurrent.eventView(component,begin,end);\r\n    \
        CalendarOutput caldavOutput = ListUtil.getReComponent(component, RecuringEve);*/\r\n\r\n  \
        System.out.print(\"Original contents of vals: \");\r\n    \
        for (int v : caldavOutput)\r\n      System.out.print(v + \" \");\r\n  }\r\n    \
        List<CalendarOutput> RecuringEve= Recurrent.eventView(component,begin,end);\r\n    \
        CalendarOutput caldavOutput = ListUtil.getReComponent(component, RecuringEve);*/\r\n\r\n  \
        System.out.print(\"Original contents of vals: \");\r\n    \
        for (int v : caldavOutput)\r\n      System.out.print(v + \" \");\r\n  }\r\n    \
        List<CalendarOutput> RecuringEve= Recurrent.eventView(component,begin,end);\r\n    \
        CalendarOutput caldavOutput = ListUtil.getReComponent(component, RecuringEve);*/\r\n\r\n  \
        System.out.print(\"Original contents of vals: \");\r\n    \
        for (int v : caldavOutput)\r\n      System.out.print(v + \" \");\r\n  }\r\n    \
        List<CalendarOutput> RecuringEve= Recurrent.eventView(component,begin,end);\r\n    \
        CalendarOutput caldavOutput = ListUtil.getReComponent(component, RecuringEve);*/\r\n\r\n  \
        System.out.print(\"Original contents of vals: \");\r\n    \
        for (int v : caldavOutput)\r\n      System.out.print(v + \" \");\r\n  }\r\n    \
        List<CalendarOutput> RecuringEve= Recurrent.eventView(component,begin,end);\r\n    \
        CalendarOutput caldavOutput = ListUtil.getReComponent(component, RecuringEve);*/\r\n\r\n  \
        System.out.print(\"Original contents of vals: \");\r\n    \
        for (int v : caldavOutput)\r\n      System.out.print(v + \" \");\r\n  }\r\n    \
        List<CalendarOutput> RecuringEve= Recurrent.eventView(component,begin,end);\r\n    \
        CalendarOutput caldavOutput = ListUtil.getReComponent(component, RecuringEve);*/\r\n\r\n  \
        System.out.print(\"Original contents of vals: \");\r\n    \
        for (int v : caldavOutput)\r\n      System.out.print(v + \" \");\r\n  }\r\n}\r\n```",
      :error => "No error",
      :anonymous => true
    }
    
    question_code = user.questions.create!(@attr) 
    question_code.feedbacks.find_by_name(@long_method).should be_true
  end
  
  it "should not detect a two short method." do
    @attr = { 
      :title => "What is Ruby on Rails?",
      :content => "I did not know what is Ruby on Rails",
      :code => "```java\r\nimport java.util.ArrayList;\r\n\r\npublic class MainClass \
      {\r\n  public static void main(String args[]) {\r\n \
        List<CalendarOutput> RecuringEve= Recurrent.eventView(component,begin,end);\r\n    \
        CalendarOutput caldavOutput = ListUtil.getReComponent(component, RecuringEve);*/\r\n\r\n  \
        System.out.print(\"Original contents of vals: \");\r\n    \
        for (int v : caldavOutput)\r\n      System.out.print(v + \" \");\r\n  }\r\n    \
        List<CalendarOutput> RecuringEve= Recurrent.eventView(component,begin,end);\r\n    \
        CalendarOutput caldavOutput = ListUtil.getReComponent(component, RecuringEve);*/\r\n\r\n  \
        System.out.print(\"Original contents of vals: \");\r\n    \
        for (int v : caldavOutput)\r\n      System.out.print(v + \" \");\r\n  }\r\n    \
        List<CalendarOutput> RecuringEve= Recurrent.eventView(component,begin,end);\r\n    \
        CalendarOutput caldavOutput = ListUtil.getReComponent(component, RecuringEve);*/\r\n\r\n  \
        System.out.print(\"Original contents of vals: \");\r\n    \
        for (int v : caldavOutput)\r\n      System.out.print(v + \" \");\r\n  }\r\n    \
        List<CalendarOutput> RecuringEve= Recurrent.eventView(component,begin,end);\r\n    \
        CalendarOutput caldavOutput = ListUtil.getReComponent(component, RecuringEve);*/\r\n\r\n  \
        System.out.print(\"Original contents of vals: \");\r\n }\r\n    \
        public static void main(String args[]) {\r\n \
        for (int v : caldavOutput)\r\n      System.out.print(v + \" \");\r\n  }\r\n    \
        List<CalendarOutput> RecuringEve= Recurrent.eventView(component,begin,end);\r\n    \
        CalendarOutput caldavOutput = ListUtil.getReComponent(component, RecuringEve);*/\r\n\r\n  \
        System.out.print(\"Original contents of vals: \");\r\n    \
        for (int v : caldavOutput)\r\n      System.out.print(v + \" \");\r\n  }\r\n    \
        List<CalendarOutput> RecuringEve= Recurrent.eventView(component,begin,end);\r\n    \
        CalendarOutput caldavOutput = ListUtil.getReComponent(component, RecuringEve);*/\r\n\r\n  \
        System.out.print(\"Original contents of vals: \");\r\n    \
        for (int v : caldavOutput)\r\n      System.out.print(v + \" \");\r\n  }\r\n    \
        List<CalendarOutput> RecuringEve= Recurrent.eventView(component,begin,end);\r\n    \
        CalendarOutput caldavOutput = ListUtil.getReComponent(component, RecuringEve);*/\r\n\r\n  \
        System.out.print(\"Original contents of vals: \");\r\n    \
        for (int v : caldavOutput)\r\n      System.out.print(v + \" \");\r\n  }\r\n}\r\n```",
      :error => "No error",
      :anonymous => true
    }
    
    question_code = user.questions.create!(@attr) 
    question_code.feedbacks.find_by_name(@long_method).should be_false
  end
  
  it "should detect too many parameters" do
    @attr = { 
      :title => "What is Ruby on Rails?",
      :content => "I did not know what is Ruby on Rails",
      :code => "```java\r\nimport java.util.ArrayList;\r\n\r\npublic class MainClass \
      {\r\n  public static void main(String args, String args, String args, String args, String args, \
        String args, String args, String args, String args, String args, \
        String args, String args, String args, String args, String args, \
        String args, String args, String args, String args, String args,) {\r\n    List<CalendarOutput> \
        RecuringEve= Recurrent.eventView(component,begin,end);\r\n    \
        CalendarOutput caldavOutput = ListUtil.getReComponent(component, RecuringEve);\r\n\r\n  \
        System.out.print(\"Original contents of vals: \");\r\n    \
        for (int v : caldavOutput)\r\n      System.out.print(v + \" \");\r\n  }\r\n}\r\n```",
      :error => "No error",
      :anonymous => true
    }
    
    question_code = user.questions.create!(@attr) 
    question_code.feedbacks.find_by_name(@many_parameters).should be_true
  end
  
  it "should update comment feedback" do
    @attr_comment_feedback = { 
      :name => "No comments in a code",
      :detail => "A good code should have comments for description.",
      :photo_link => "www.google.com"
    }

    @attr = { 
      :title => "What is Ruby on Rails?",
      :content => "I did not know what is Ruby on Rails",
      :code => "```java\r\nimport java.util.ArrayList;\r\n\r\npublic class MainClass \
      {\r\n  public static void main(String args, String args, String args, String args, String args, \
        String args, String args, String args, String args, String args, \
        String args, String args, String args, String args, String args, \
        String args, String args, String args, String args, String args,) {\r\n    List<CalendarOutput> \
        RecuringEve= Recurrent.eventView(component,begin,end);\r\n    \
        CalendarOutput caldavOutput = ListUtil.getReComponent(component, RecuringEve);\r\n\r\n  \
        System.out.print(\"Original contents of vals: \");\r\n    \
        for (int v : caldavOutput)\r\n      System.out.print(v + \" \");\r\n  }\r\n}\r\n```",
      :error => "No error",
      :anonymous => true
    }
    
    question_code = user.questions.create!(@attr) 
    question_code.code = '```java correct //comments ```'
    question_code.save
    question_code.feedbacks.find_by_name(@attr_comment_feedback[:name]).should be_false
  end
  
  it "should update class feedback" do
    @attr_class_feedback = { 
      :name => "Large class",
      :detail => "A class is huge. It is hard to be maintananced.",
      :photo_link => "www.google.com"
    }
    
    question_code = user.questions.create!(@attr) 
    question_code.feedbacks << Feedback.find_or_create_by_name(@attr_class_feedback[:name])
    question_code.code = '```java correct //comments ```'
    question_code.save
    question_code.feedbacks.find_by_name(@attr_class_feedback[:name]).should be_false
  end
  
  it "should update method feedback" do
    @attr_method_feedback = { 
      :name => "Long method",
      :detail => "A method is long. It is hard to be maintananced.",
      :photo_link => "www.google.com"
    }
    
    question_code = user.questions.create!(@attr) 
    question_code.feedbacks << Feedback.find_or_create_by_name(@attr_method_feedback[:name])
    question_code.code = '```java correct //comments ```'
    question_code.save
    question_code.feedbacks.find_by_name(@attr_method_feedback[:name]).should be_false
  end
  
  it "should update method feedback" do
    @attr_feedback = { 
      :name => "A too long code",
      :detail => "Your code is too long. It is hard to read.",
      :photo_link => "www.google.com"
    }
    
    question_code = user.questions.create!(@attr) 
    question_code.feedbacks << Feedback.find_or_create_by_name(@attr_feedback[:name])
    question_code.code = '```java correct //comments ```'
    question_code.save
    question_code.feedbacks.find_by_name(@attr_feedback[:name]).should be_false
  end
  
  it "should update method feedback" do
    @attr_parameters_feedback = { 
      :name => "Too many parameters",
      :detail => "A method is long. It is hard to be maintananced.",
      :photo_link => "www.google.com"
    }
    
    question_code = user.questions.create!(@attr) 
    question_code.feedbacks << Feedback.find_or_create_by_name(@attr_parameters_feedback[:name])
    question_code.code = '```java correct //comments ```'
    question_code.save
    question_code.feedbacks.find_by_name(@attr_parameters_feedback[:name]).should be_false
  end
end
