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
#  z_scores               :integer
#  sex                    :string(255)
#  level                  :string(255)
#

class User < ActiveRecord::Base
  include PublicActivity::Model
	rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :confirmed_at, 
                  :school, :sex, :level, :points, :z_scores, :tag_list
  acts_as_taggable
  # tracked 
  tracked  owner: :owner, params: { email: :email, sign_in_count: :sign_in_count, current_sign_in_at: :current_sign_in_at, current_sign_in_ip: :current_sign_in_ip, name: :name, school: :school, points: :points, z_scores: :z_scores, sex: :sex ,level: :level }
  
  has_many :questions, :inverse_of => :user
  has_many :usefuls, :inverse_of => :user
  has_many :comments, :inverse_of => :user
  has_many :notifications, :inverse_of => :user
  has_many :replies, :inverse_of => :user
  has_and_belongs_to_many :courses
  before_create :init
  
  def add_expert_role
    scores = z_score
    if scores >= 1.65 && !(has_role? :expert)
      if add_role :expert
        self.create_activity key: 'user.add.expert'
      end
    elsif (has_role? :expert) && scores < 1.65 && !(has_role? :ta) && !(has_role? :instructor)
      if remove_role :expert
        self.create_activity key: 'user.remove.expert'
      end
    end 
  end
  
  def z_score
    number_of_answer = comments.all.count
    number_of_question = questions.all.count
    if number_of_answer == 0 && number_of_question == 0
      self.z_scores = 0
    else
      self.z_scores = (( number_of_answer - number_of_question ) / Math.sqrt( number_of_answer + number_of_question )).round(5)
    end
  end
  
  def add_points(new_points)
    self.lock!
    self.points += new_points
    self.save
  end
  
  def deduct_points(new_points)
    self.lock!
    self.points -= new_points
    self.save
  end
  
  def user_feed(questionArray, commentArray)
    questionIndex = 0
    commentIndex = 0
    result = Array.new
     
    while questionIndex < questionArray.size || commentIndex < commentArray.size
      if questionIndex < questionArray.size && commentIndex < commentArray.size
        if questionArray[questionIndex].created_at > commentArray[commentIndex].created_at
          result = result << questionArray[questionIndex]
          questionIndex = questionIndex + 1
        else
          result = result << commentArray[commentIndex]
          commentIndex = commentIndex + 1
        end
      elsif questionIndex < questionArray.size
        result = result << questionArray[questionIndex]
        questionIndex  = questionIndex + 1
      elsif commentIndex < commentArray.size
        result = result << commentArray[commentIndex]
        commentIndex = commentIndex + 1
      end
    end
    result
  end
  
  private 
  def init
    self.points ||= 0
    self.z_scores ||= 0
  end
  
  def owner
    self
  end
end
