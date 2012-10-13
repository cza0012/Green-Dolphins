require 'spec_helper'

describe "Notifications" do
  subject{ page }
  before(:each) do    
            visit new_user_session_path
            @user = FactoryGirl.create(:user)
            fill_in "user_email", with: @user.email
            fill_in "user_password", with: @user.password
            click_button "Sign in"
  end
  
  describe "PUT /notifications" do
    before{ 
      @expert = FactoryGirl.create(:user, name: 'expert man', email: 'expertman@example.com')
      @expert.add_role :expert
      visit new_question_path
    }
            
    it "has a notification field." do
      @expert.should be_has_role :expert
      should have_selector('td', text: 'expert man')
      should have_selector('label',  text: 'User')
    end 
  end
  
  describe "PUT /notifications" do
    before{ 
      @expert1 = FactoryGirl.create(:user, name: 'expert man', email: 'expertman@example.com')
      @expert2 = FactoryGirl.create(:user, name: 'expert woman', email: 'expertwoman@example.com')
      @expert1.add_role :expert
      @expert2.add_role :expert
      visit new_question_path
    }
            
    it "has a notification field." do
      @expert1.should be_has_role :expert
      @expert2.should be_has_role :expert
      should have_selector('td', text: 'expert man')
      should have_selector('td', text: 'expert woman')
      should have_selector('label',  text: 'User', count: 2)
    end 
  end
  
  describe "PUT /notifications" do
    before{ 
      @expert1 = FactoryGirl.create(:user, name: 'expert man', email: 'expertman@example.com')
      @expert2 = FactoryGirl.create(:user, name: 'expert woman', email: 'expertwoman@example.com')
      @expert1.add_role :expert
      @expert2.add_role :expert
      visit new_question_path
      fill_in "question_title", with: 'Hello'
      fill_in "question_content", with: 'Hello information'
      fill_in "question_code", with: '<h1>Hello</h1>'
      fill_in "question_error", with: 'Hello error'
      fill_in "question_notifications_attributes_0_user_id", with: @expert1.id
    }
            
    it "has sent notifications to the experts." do
      @expert1.should be_has_role :expert
      @expert2.should be_has_role :expert
      expect{click_button "Create Question"}.to change(Notification, :count).by(1)
    end 
  end
  describe "PUT /notifications" do
    before{ 
      @expert1 = FactoryGirl.create(:user, name: 'expert man', email: 'expertman@example.com')
      @expert2 = FactoryGirl.create(:user, name: 'expert woman', email: 'expertwoman@example.com')
      @expert1.add_role :expert
      @expert2.add_role :expert
      visit new_question_path
      fill_in "question_title", with: 'Hello'
      fill_in "question_content", with: 'Hello information'
      fill_in "question_code", with: '<h1>Hello</h1>'
      fill_in "question_error", with: 'Hello error'
      fill_in "question_notifications_attributes_0_user_id", with: @expert1.id
      fill_in "question_notifications_attributes_1_user_id", with: @expert2.id
      click_button "Create Question"
    }
            
    it "has sent notifications to two experts." do
      visit notifications_path
      save_and_open_page
      should have_selector('td', text: 'expert man please helps me!')
      should have_selector('td', text: 'expert woman please helps me!')
    end 
  end
end
