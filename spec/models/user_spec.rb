# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  school                 :string(255)
#  points                 :integer
#  sex                    :string(255)
#  level                  :string(255)
#  z_scores               :float
#

require 'spec_helper'

describe User do
  let(:asker) { FactoryGirl.create(:user) }
  let(:question) { FactoryGirl.create(:question, user_id: asker.id) }
  before(:each) do
    @attr = { 
      :name => "Example User",
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar",
      :school => "Auburn University",
      :sex => 1,
      :level => 1
    }
    @question_attr = { 
      :title => "What is Ruby on Rails?",
      :content => "I did not know what is Ruby on Rails",
      :code => "<pre></pre>",
      :error => "No error",
      :anonymous => false
    }
    @comment_attr = { 
      :content  => "Good job",
      :line  => 9,
      :code => "<b>hi</b>",
      :anonymous => false,
      :question_id => question.id
    }
  end
  
  it "should create a new instance given a valid attribute" do
    User.create!(@attr)
  end
  
  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end
  
  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end
  
  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  
  it "should reject duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  describe "passwords" do

    before(:each) do
      @user = User.new(@attr)
    end

    it "should have a password attribute" do
      @user.should respond_to(:password)
    end

    it "should have a password confirmation attribute" do
      @user.should respond_to(:password_confirmation)
    end
  end
  
  describe "password validations" do

    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end
    
    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end
  end
  
  describe "password encryption" do
    
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password attribute" do
      @user.encrypted_password.should_not be_blank
    end
  end
  
  describe "has z-score equals" do
    context "1 point by 0 question and 0 answer" do
      before{
        @user1 = User.create!(@attr)
      }
      it{@user1.z_score().should == 0}
    end
    
    context "-1 point by 1 question and 0 answer" do
    
      before{
        @user2 = User.create!(@attr)
        @user2.questions.create!(@question_attr)
      }
      
        it{@user2.z_score().should == -1} 
    end
    
    context "1 point by 0 question and 1 answer" do

      before{
        @user3 = User.create!(@attr)
        @user3.comments.create!(@comment_attr)
      }
      
        it{@user3.z_score().should == 1} 
    end
    
    context "1 point by 0 question and 1 answer" do

      before{
        @user3 = User.create!(@attr)
        @user3.comments.create!(@comment_attr)
      }
      
        it{@user3.z_score().should == 1} 
    end
    
    context "3 point by 5 question and 20 answer" do

      before{
        @user4 = User.create!(@attr)
        5.times do 
          @user4.questions.create!(@question_attr)
        end
        20.times do
          @user4.comments.create!(@comment_attr)
        end
      }
      
        it{@user4.z_score().should == 3} 
    end
  end
  
  describe "has points" do 
    before{
      @user = User.create!(@attr)
      
      @fast_question_attr = { 
        :title => "What is Ruby on Rails?",
        :content => "I did not know what is Ruby on Rails",
        :code => "<pre></pre>",
        :error => "No error",
        :anonymous => false,
        :fast_answer => true
      }
      
    }
    
    context "A user has 0 point after initialized." do
      it{@user.points.should == 0}
    end
    
    context "A user has been added 5 points." do
      before{
        @user.add_points(5)
      }
      it{@user.points.should == 5}
    end
    
    context "A user has been deducted 5 points." do
      before{
        @user.deduct_points(5)
      }
      it{@user.points.should == -5}
    end
  end
  
  describe "has added an expert role" do
    before{
          @user = User.create(@attr)
    }
    
   context "A user has not have an expert role" do
      it{@user.should_not be_has_role :expert}
   end
   
   context "A user has an expert role from 4 answers." do
    before{
      4.times do
        @user.comments.create!(@comment_attr)
      end
      @user.add_expert_role
    }
     it{@user.should be_has_role :expert}
     it{@user.z_scores.should == 2}
   end
   
   context "A user has been tracked, when an expert role added." do
    before{
      4.times do
        @user.comments.create!(@comment_attr)
      end
    }
     it{expect { @user.add_expert_role }.to change{ PublicActivity::Activity.count }.by(2)}
   end
   
    context "A user has been tracked, when an expert role removed." do
      before{
        4.times do
          @user.comments.create!(@comment_attr)
        end
        @user.add_expert_role
        4.times do
          @user.questions.create!(@question_attr)
        end
      }
      it{expect { @user.add_expert_role }.to change{ PublicActivity::Activity.count }.by(2)}
   end
   
   context "A user got a notification, when an expert role added." do
    before{
      4.times do
        @user.comments.create!(@comment_attr)
      end
    }
     it{expect { @user.add_expert_role }.to change{ Notification.count }.by(1)}
   end
   
    context "A user witdraw an expert, when an expert role removed." do
      before{
        4.times do
          @user.comments.create!(@comment_attr)
        end
        @user.add_expert_role
        4.times do
          @user.questions.create!(@question_attr)
        end
      }
      it{expect { @user.add_expert_role }.to change{ Notification.count }.by(1)}
   end
   
   context "A user got a notification message for his unexpert, when an expert role added." do
    before{
      4.times do
        @user.comments.create!(@comment_attr)
      end
      @user.add_expert_role
      4.times do
        @user.questions.create!(@question_attr)
      end
      @user.add_expert_role
      @notification = Notification.last
    }
    it{ @notification.user_id.should == @user.id }
    it{ @notification.content.should == 'NotExpert' }
   end
   
   context "A user got a notification message for his expert, when an expert role added." do
    before{
      4.times do
        @user.comments.create!(@comment_attr)
      end
      @user.add_expert_role
      @notification = Notification.last
    }
    it{ @notification.user_id.should == @user.id }
    it{ @notification.content.should == 'Expert' }
   end
   
   context "A user lost an expert role from 4 additional questions." do
     before{
       4.times do
         @user.comments.create!(@comment_attr)
       end
       @user.add_expert_role
       4.times do
         @user.questions.create!(@question_attr)
       end
       @user.add_expert_role
     }
      it{@user.should_not be_has_role :expert}
      it{@user.z_scores.should == 0}
    end
  end
  
  describe "has added an feed" do
    before{
      @user = User.create!(@attr)
    }
    
    context "A user have answers before questions." do
      before{
        4.times do
          @user.comments.create!(@comment_attr)
          # sleep(1)
        end
        4.times do
          @user.questions.create!(@question_attr)
          # sleep(1)
        end
        @questions = @user.questions.where(:anonymous => false).order('created_at DESC')
        @comment = @user.comments.where(:anonymous => false).order('created_at DESC')
      }
       it{@user.user_feed(@questions, @comment).size.should == 8}
     end
  
    context "A user have questions before answers." do
      before{
        4.times do
          @user.questions.create!(@question_attr)
          # sleep(1)
        end
        4.times do
          @user.comments.create!(@comment_attr)
          # sleep(1)
        end
        4.times do
          @user.questions.create!(@question_attr)
          # sleep(1)
        end
        @questions = @user.questions.where(:anonymous => false).order('created_at DESC')
        @comment = @user.comments.where(:anonymous => false).order('created_at DESC')
      }
       it{@user.user_feed(@questions, @comment).size.should == 12}
     end
  end
end
