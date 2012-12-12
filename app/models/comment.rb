# == Schema Information
#
# Table name: comments
#
#  id          :integer          not null, primary key
#  content     :text
#  line        :integer
#  code        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#  question_id :integer
#  anonymous   :boolean
#  hidden      :boolean
#

class Comment < ActiveRecord::Base
  attr_accessible :anonymous, :code, :content, :line, :user_id, :question_id, :hidden
  
  validates :user_id, :question_id, :line, presence: true
  validates :question_id, presence: true
  
  has_many :usefuls, :as => :usefulable
  belongs_to :user, :inverse_of => :comments
  belongs_to :question, :inverse_of => :comments
  has_one :good_answer, :inverse_of => :comment
  
  def comment_owner? user
    User.find(user_id) == user
  end
  
  def delay_comment user
    if user.has_role?(:ta)
      delay_ta_comment
    end
    if user.has_role?(:instructor)
      delay_instructor_comment
    end
  end
  
  def delay_ta_comment
    self.hidden = false
    save
  end
  handle_asynchronously :delay_ta_comment, :queue => 'comments', :run_at => Proc.new { 1.minutes.from_now }
  
  def delay_instructor_comment
    self.hidden = false
    save
  end
  handle_asynchronously :delay_instructor_comment, :queue => 'comments', :run_at => Proc.new { 2.hours.from_now }
end
