# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  content    :text
#  code       :text
#  error      :text
#  anonymous  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

class Question < ActiveRecord::Base
  attr_accessible :anonymous, :code, :content, :error, :timestamp, :title, :user_id
  
  validates :user_id, presence: true
  
  belongs_to :user, :inverse_of => :questions
  has_many :usefuls, :as => :usefulable
  has_many :comments, :inverse_of => :question
  has_and_belongs_to_many :feedbacks
end
