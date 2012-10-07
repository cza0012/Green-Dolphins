require 'spec_helper'

describe "Usefuls" do
  subject{ page }
  before(:each) do    
            visit new_user_session_path
            @user = FactoryGirl.create(:user)
            @question = FactoryGirl.create(:question, user_id: @user.id)
            fill_in "user_email", with: @user.email
            fill_in "user_password", with: @user.password
            click_button "Sign in"
            FactoryGirl.create(:comment, question_id: @question.id, user_id: @user.id)
            visit question_path(@question) 
  end
  
  describe "GET /usefuls" do
    it "There are useful links." do
      should have_selector('a',  text: /Useful/, count: 2)
    end
  end
  
  describe "Post /useful" do
    it "saves a useful comment in the database." do
      expect { click_link "Useful comment" }.to change(Useful, :count).by(1)
    end
  end
  
  describe "Post /useful" do
    it "saves a useful question in the database." do
      expect { click_link "Useful question" }.to change(Useful, :count).by(1)
    end
  end
  
  describe "Post /useful" do
    before{
      click_link "Useful comment" 
      visit user_path(@user.id)
    }
    it "a user gets point after click a useful link." do
      should have_selector('p',  text: 'Points: 2')
    end
  end
  
end
