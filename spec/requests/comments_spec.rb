require 'spec_helper'

describe "Comments" do
  subject{ page }
  before(:each) do    
            visit new_user_session_path
            @user = FactoryGirl.create(:user)
            @question = FactoryGirl.create(:question, user_id: @user.id)
            fill_in "user_email", with: @user.email
            fill_in "user_password", with: @user.password
            click_button "Sign in"
  end
  
  describe "GET /comments" do
    before{ visit comments_path }
            
    it "has a new comment page." do
      should have_selector('h1', text: 'Listing comments')
      should have_link('New Comment')
      expect { click_link "New Comment" }.not_to change(Question, :count)
      should have_selector('h1', text: 'New comment')
      should have_selector('label',  text: 'Content')
      should have_selector('label',  text: 'Code')
      should have_selector('label',  text: 'Anonymous')
    end 
  end
  
  describe "Post /comments" do
    before{ visit new_comment_path 
      fill_in "comment_content", with: 'Hello'
      fill_in "comment_code", with: '<h1>Hello</h1>'
    }

    it "is created" do
      expect { click_button "Create Comment" }.to change(Comment, :count).by(1)
      should have_selector('p', text: 'Comment was successfully created.')
    end
  end
  
  describe "Post /comments" do
    before{ visit new_comment_path 
      fill_in "comment_content", with: 'Hello'
      fill_in "comment_code", with: '<h1>Hello</h1>'
      click_button "Create Comment"
      visit user_path(@user.id)
    }

    it "makes a user gets points." do
      should have_selector('p',  text: 'Points: 10')
    end
  end
  
  describe "Post /comments" do
    before{ visit question_path(@question.id)
      fill_in "comment_content", with: 'Hello'
      fill_in "comment_code", with: '<h1>Hello</h1>'
    }

    it "a user post a comment in a question." do
      expect { click_button "Create Comment" }.to change(Comment, :count).by(1)
      should have_selector('p', text: 'Comment was successfully created.')
      should have_selector('p',  text: 'User_id: ' + @user.name)
      should have_selector('p',  text: 'Question_id: ' + @question.id.to_s)
    end
  end
  
end
