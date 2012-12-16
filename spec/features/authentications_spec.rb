require 'spec_helper'

describe "Authentications functions" do
  
  subject{ page }
  
  describe "GET /sign in" do
    before { visit new_user_session_path }
    
    it { should have_selector('h2', text: 'Sign in') 
        should have_selector('label',  text: 'Email')
        should have_selector('label',  text: 'Password')
        should have_selector('label', text:'Remember me')
        should have_link('Sign up')
        should have_link('Forgot your password?')
        should have_link('Didn\'t receive confirmation instructions?')}
        
  end
  
  describe "GET /empty sign in" do
    before { visit new_user_session_path }
    
    before do
      click_button "Sign in"
    end
    
    it { should have_selector('h2', text: 'Sign in') 
        should have_selector('label',  text: 'Email')
        should have_selector('label',  text: 'Password')
        should have_selector('label', text: 'Remember me')
        should have_selector('div', text: 'Invalid email or password.') }

  end
  
  describe "GET /incorrect sign in" do
    before { visit new_user_session_path }
    
    before do
      fill_in "user_email", with: "wrong@gmail.com"
      fill_in "user_password", with: "wrongpass"
    end
    
    before do
      click_button "Sign in"
    end
    
    it { should have_selector('h2', text: 'Sign in') 
        should have_selector('label',  text: 'Email')
        should have_selector('label',  text: 'Password')
        should have_selector('label', text: 'Remember me')
        should have_selector('div', text: 'Invalid email or password.') }
  end
  
  describe "GET /sucessful sign in" do
    before { visit new_user_session_path }
    
    before do
      @user = FactoryGirl.create(:user)
      fill_in "user_email", with: @user.email
      fill_in "user_password", with: @user.password
      click_button "Sign in"
    end
    
    it {should have_selector('a', text: 'Logout')
      should have_selector('a', text: 'Logout')
      should have_selector('a', text: 'Edit account')}
  end
  
  describe "GET / Sign up" do
    before { visit new_user_registration_path }
    
    it {should have_selector('h2', text: 'Sign up') 
        should have_selector('label',  text: 'Name')
        should have_selector('label',  text: 'Email')
        should have_selector('label', text: 'Password')
        should have_selector('div', text: 'Password confirmation')}
  end
  
  describe "GET / A short password Sign up" do
    before { visit new_user_registration_path }
    
    before do
        fill_in "user_name", with: "Tester 1"
        fill_in "user_email", with: "wrong@gmail.com"
        fill_in "user_password", with: "12345"
        fill_in "user_password_confirmation", with: "12345"
    end
    
    it {expect { click_button "Sign up" }.not_to change(User, :count)
        should have_selector('h2', text: 'error prohibited this user from being saved:')
        should have_selector('li', text: 'Password is too short (minimum is 6 characters)')}
  end
  
  describe "GET / A short password Sign up" do
    before { visit new_user_registration_path }
    
    before do
        fill_in "user_name", with: "Tester 1"
        fill_in "user_email", with: "wrong@gmail.com"
        fill_in "user_password", with: "12345"
        fill_in "user_password_confirmation", with: "12345"
    end
    
    it {expect { click_button "Sign up" }.not_to change(User, :count)
        should have_selector('h2', text: '1 error prohibited this user from being saved:')
        should have_selector('li', text: 'Password is too short (minimum is 6 characters)')}
  end
  
  describe "GET / Password does not match Sign up" do
    before { visit new_user_registration_path }
    
    before do
        fill_in "user_name", with: "Tester 1"
        fill_in "user_email", with: "wrong@gmail.com"
        fill_in "user_password", with: "123456"
        fill_in "user_password_confirmation", with: "654321"
    end
    
    it {expect { click_button "Sign up" }.not_to change(User, :count)
        should have_selector('h2', text: '1 error prohibited this user from being saved:')
        should have_selector('li', text: 'Password doesn\'t match confirmation')}
  end
  
  describe "GET / Password does not match Sign up" do
    before { visit new_user_registration_path }
    
    before do
        @user = FactoryGirl.create(:user)
        fill_in "user_name", with: "Tester 1"
        fill_in "user_email", with: @user.email
        fill_in "user_password", with: "123456"
        fill_in "user_password_confirmation", with: "123456"
    end
    
    it {expect { click_button "Sign up" }.not_to change(User, :count)
        should have_selector('h2', text: '1 error prohibited this user from being saved:')
        should have_selector('li', text: 'Email has already been taken')}
  end
  
  describe "GET / Successful Sign up" do
     before { visit new_user_registration_path }

     before do
         fill_in "user_name", with: "Pointer"
         fill_in "user_email", with: "wrong@gmail.com"
         fill_in "user_password", with: "123456"
         fill_in "user_password_confirmation", with: "123456"
     end

     it {expect { click_button "Sign up" }.to change(User, :count)
         should have_selector('div', text: 'A message with a confirmation link has been sent to your email address. Please open the link to activate your account.')
         @pointer = User.find_by_name("Pointer")
         @pointer.points.should == 0
         @pointer.z_scores.should == 0}
   end
  
end
