# == Schema Information
#
# Table name: comments
#
#  id          :integer          not null, primary key
#  content     :text
#  line        :integer
#  code        :text
#  anonymous   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#  question_id :integer
#

class Comment < ActiveRecord::Base
  attr_accessible :anonymous, :code, :content, :line, :user_id, :question_id
  
  validates :user_id, :question_id, :line, presence: true
  validates :question_id, presence: true
  
  has_many :usefuls, :as => :usefulable
  belongs_to :user, :inverse_of => :comments
  belongs_to :question, :inverse_of => :comments
  has_one :good_answer, :inverse_of => :comment
end
