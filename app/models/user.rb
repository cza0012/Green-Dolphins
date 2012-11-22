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
#  sex                    :integer
#  level                  :integer
#  points                 :integer
#  z_scores               :integer
#

class User < ActiveRecord::Base
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
  
  has_many :questions, :inverse_of => :user
  has_many :usefuls, :inverse_of => :user
  has_many :comments, :inverse_of => :user
  has_many :notifications, :inverse_of => :user
  has_and_belongs_to_many :courses
  before_create :init
  
  def add_expert_role
    scores = z_score
    if scores >= 1.65
      add_role :expert
    elsif (has_role? :expert) && scores < 1.65
      remove_role :expert
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
  
  private 
  def init
    self.points ||= 0
    self.z_scores ||= 0
  end
end
