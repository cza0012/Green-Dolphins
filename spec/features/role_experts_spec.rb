require 'spec_helper'

describe "RoleExperts" do
  subject{ page }
  before{  
    @user = FactoryGirl.create(:user)
    @question = FactoryGirl.create(:question, user_id: @user.id)
    
    @question_attr = { 
      :title => "What is Ruby on Rails?",
      :content => "I did not know what is Ruby on Rails",
      :code => "<pre></pre>",
      :error => "No error",
      :anonymous => true
    }
    @comment_attr = { 
      :content  => "Good job",
      :line  => 9,
      :code => "<b>hi</b>",
      :anonymous => false,
      :question_id => @question.id
    }
    
    visit new_user_session_path
    fill_in "user_email", with: @user.email
    fill_in "user_password", with: @user.password
    click_button "Sign in"
    visit question_path(@question) 
  }
  
  context "GET /role_experts" do
    it "is not assigned to a user." do
      @user.should_not be_has_role :expert
    end
  end
  
  context "POST /role_expert" do
    before{
      5.times do
        @user.comments.create!(@comment_attr)
      end
      fill_in "comment_content", with: 'Hello'
      fill_in "comment_code", with: '<h1>Hello</h1>'
      click_button "Create Comment"
    }
    it "is assigned to a user by the fifth answers." do
      save_and_open_page
      @user.should have(6).comments
      @user.should have(1).questions
      @user.should be_has_role :expert
    end
  end
  
  context "POST /role_expert" do
    before{
      @user.add_role :expert
      visit new_question_path
      fill_in "question_title", with: 'Hello'
      fill_in "question_content", with: 'Hello information'
      fill_in "question_code", with: '<h1>Hello</h1>'
      fill_in "question_error", with: 'Hello error'
      click_button "Create Question"
    }
    it "is removed from a user by the fifth questions." do
      @user.should_not be_has_role :expert
    end
  end
end
