require 'spec_helper'

describe "Questions" do
  subject{ page }
  before(:each) do    
            visit new_user_session_path
            @user = FactoryGirl.create(:user,:student)
            fill_in "user_email", with: @user.email
            fill_in "user_password", with: @user.password
            click_button "Sign in"
  end
  
  describe "GET /questions" do
    before{ visit questions_path }
            
    it "has a new question page." do
      should have_selector('h1', text: 'Questions')
      should have_link('New Question')
      expect { click_link "New Question" }.not_to change(Question, :count)
      should have_selector('h1', text: 'New question')
      should have_selector('label',  text: 'Title')
      should have_selector('label',  text: 'Content')
      should have_selector('label',  text: 'Code')
      should have_selector('label',  text: 'Error')
      should have_selector('label',  text: 'Anonymous')
      should have_selector('label',  text: 'Content')
      should have_selector('label',  text: 'Code')
      should have_selector('label',  text: 'Anonymous')
    end 
  end
  
  describe "Post /questions/new" do
    before{ visit new_question_path 
      fill_in "question_title", with: 'Hello'
      fill_in "question_content", with: 'Hello information'
      fill_in "question_code", with: '<h1>Hello</h1>'
      fill_in "question_error", with: 'Hello error'
    }

    it "is created" do
      expect { click_button "Create Question" }.to change(Question, :count).by(1)
    end
  end
  
  describe "Post /questions/new" do
     before{ visit new_question_path 
       fill_in "question_title", with: 'Hello'
       fill_in "question_content", with: 'Hello information'
       fill_in "question_code", with: '<h1>Hello</h1>'
       fill_in "question_error", with: 'Hello error'
       click_button "Create Question" 
       visit user_path(@user.id)
     }

     it "makes a user gets points." do
       should have_selector('h1',  text: '5 Points')
     end
   end
  
  describe "GET 2 answers of a question" do
    before{ 
      @question2Answers = FactoryGirl.create(:question, user_id: @user.id)
      2.times {
        FactoryGirl.create(:comment, question_id: @question2Answers.id, user_id: @user.id)
      }
      visit question_path(@question2Answers) 
    }

    it "is created" do
      should have_selector('b',  text: '2 Answers')
      should have_selector('p',  text: '' + @question2Answers.id.to_s)
    end
  end
  
  describe "GET an owner of a question" do
    before{ 
      @question = FactoryGirl.create(:question, user_id: @user.id)
      visit question_path(@question.id) 
    }

    it "is created" do
      # save_and_open_page
      should have_selector('p',  text: '' + User.find(@question.user_id).name)
    end
  end
  
  describe "GET an anonymous owner of a question" do
    before{ 
      @question = FactoryGirl.create(:question, user_id: @user.id, anonymous: 1)
      visit question_path(@question.id) 
    }

    it "is created" do
      # save_and_open_page
      should have_selector('p',  text: 'An anonymous user')
    end
  end
  
  describe "Post /questions/new and automate feedback" do
     before{ visit new_question_path 
       fill_in "question_title", with: 'Hello'
       fill_in "question_content", with: 'Hello information'
       fill_in "question_code", with: '```java
              import java.util.ArrayList;

              public class MainClass {
                public static void main(String args[]) {
                  List<CalendarOutput> RecuringEve= Recurrent.eventView(component,begin,end);
                  CalendarOutput caldavOutput = ListUtil.getReComponent(component, RecuringEve);

                System.out.print("Original contents of vals: ");
                  for (int v : caldavOutput)
                    System.out.print(v + " ");
                }
              }```'
       fill_in "question_error", with: 'Hello error'
       click_button "Create Question"
     }

     it "makes a user gets points." do
       # save_and_open_page
       should have_selector('td',  text: 'No comments in a code')
       should have_selector('td',  text: 'A good code should have comments for description.')
     end
   end
   
   describe "Can edit a user's question" do
     before{ 
       @question = FactoryGirl.create(:question, user_id: @user.id, anonymous: 1)
       visit question_path(@question.id) 
     }

     it "is created" do
       # save_and_open_page
       should have_selector('a',  text: /\AEdit\z/)
       should have_selector('a',  text: /\ADestroy\z/)
     end
   end
   
   describe "Cannot edit other users question" do
     before{ 
       user2 = FactoryGirl.create(:user,email: 'example@auburn.edu')
       @question = FactoryGirl.create(:question, user_id: user2.id, anonymous: 1)
       visit question_path(@question.id)
     }

     it "is created" do
       save_and_open_page
       should_not have_selector('a',  text: /\AEdit\z/)
       should_not have_selector('a',  text: /\ADestroy\z/)
     end
   end
   
end
