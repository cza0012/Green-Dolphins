# == Schema Information
#
# Table name: comments
#
#  id              :integer          not null, primary key
#  content         :text
#  line            :integer
#  code            :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :integer
#  question_id     :integer
#  anonymous       :boolean
#  hidden          :boolean
#  deleted_comment :boolean
#

class Comment < ActiveRecord::Base
  include PublicActivity::Model
  attr_accessible :anonymous, :code, :content, :line, :user_id, :question_id, :hidden, :deleted_comment
  
  validates :user_id, :question_id, :line, :content, presence: true
  # tracked
  tracked owner: :owner, params: { content: :content, line: :line, code: :code, question_id: :question_id, anonymous: :anonymous, hidden: :hidden, deleted_comment: :deleted_comment}
  
  has_many :usefuls, :as => :usefulable
  belongs_to :user, :inverse_of => :comments
  belongs_to :question, :inverse_of => :comments
  has_one :good_answer, :inverse_of => :comment
  has_many :replies,  :inverse_of => :comment
  has_many :notifications, :as => :sendable
  
  def archive_comment
    self.lock!
    self.deleted_comment = true
    self.save
  end
  
  def comment_owner? user
    User.find(user_id) == user
  end
  
  def delay_comment user
    if user.has_role?(:ta)
        question = Question.find(self.question_id)
        limitedTime = question.created_at + 12.hours
        waitingTime = limitedTime.to_time - DateTime.current().to_time
        if waitingTime > 0
          delay({:run_at => waitingTime.seconds.from_now}).delay_ta_comment
        end
    end
    if user.has_role?(:instructor)
        question = Question.find(self.question_id)
        limitedTime = question.created_at + 1.days
        waitingTime = limitedTime.to_time - DateTime.current().to_time
        if waitingTime > 0
          delay({:run_at => waitingTime.seconds.from_now}).delay_instructor_comment
        end
    end
  end
  
  def delay_ta_comment
    self.lock!
    self.hidden = false
    save
  end
  # handle_asynchronously :delay_ta_comment, :queue => 'comments', :run_at => Proc.new { 1.hours.from_now }
  
  def delay_instructor_comment
    self.lock!
    self.hidden = false
    save
  end
  # handle_asynchronously :delay_instructor_comment, :queue => 'comments', :run_at => Proc.new { 2.hours.from_now }
  
  private
  def owner
    User.find(user_id)
  end
end
