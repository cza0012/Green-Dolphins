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
                  :school, :sex, :level
  
  has_many :questions, :inverse_of => :user
  has_many :usefuls, :inverse_of => :user
  has_many :comments, :inverse_of => :user
  has_and_belongs_to_many :courses
  
  def z_score ( number_of_answer, number_of_question )
    different_between_answer_question = ( number_of_answer+1 ) - ( number_of_question+1 )
    @z_score = (( different_between_answer_question ) / Math.sqrt( different_between_answer_question )).round(5)
  end
end
