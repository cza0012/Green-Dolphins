require 'spec_helper'

describe "GoodAnswers" do
  subject{ page }
  before(:each) do    
            visit new_user_session_path
            @user = FactoryGirl.create(:user)
            @userAnswer = FactoryGirl.create(:user, email: "correctanswer@auburn.edu")
            @question2Answers = FactoryGirl.create(:question, user_id: @user.id)
            fill_in "user_email", with: @user.email
            fill_in "user_password", with: @user.password
            click_button "Sign in"
            FactoryGirl.create(:comment, question_id: @question2Answers.id, user_id: @userAnswer.id)
            visit question_path(@question2Answers) 
  end
  
  describe "Post /good_answers" do
    it "saves in the database." do
      expect { click_link "The best answer" }.to change(GoodAnswer, :count).by(1)
    end
  end
  
  describe "Post /good_answers" do
     before{ 
       click_link "The best answer"
       visit user_path(@user.id)
      }
      
    it "a user who give the correct answer gets points." do
      should have_selector('p',  text: 'Points: 5')
    end
  end
  
  describe "Post /good_answers" do
     before{ 
       click_link "The best answer"
       visit user_path(@userAnswer.id)
      }
      
    it "a user whose the correct answer gets points." do
      should have_selector('p',  text: 'Points: 10')
    end
  end
end
