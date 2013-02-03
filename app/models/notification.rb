# == Schema Information
#
# Table name: notifications
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  content       :text
#  read          :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  sendable_id   :integer
#  sendable_type :string(255)
#

class Notification < ActiveRecord::Base
  include PublicActivity::Model
  attr_accessible :content, :read, :user_id
  
  tracked owner: :owner, recipient: :recipient, params: { content: :content, read: :read, sendable_id: :sendable_id, sendable_type: :sendable_type }
  
  belongs_to :user, :inverse_of => :notifications
  belongs_to :sendable, :polymorphic => true 
  after_validation :set_message
  after_save :pay_point, :notification_deliver 
  
  def read_notification
    self.lock!
    self.read = true
    self.save
  end
  
  def notification_deliver
    user = User.find(user_id)
    if !user.blank?
      if sendable_type == 'Question'
        NotificationMailer.expert_notification(user, sendable_id).deliver
      elsif sendable_type == 'Comment'
        sender = Comment.find(sendable_id).user
        if !(sender.has_role?(:instructor) || sender.has_role?(:ta))
          NotificationMailer.comment_notification(user, sendable_id).deliver
        end
      elsif sendable_type == 'GoodAnswer'
        NotificationMailer.good_answer_notification(user, sendable_id).deliver
      elsif sendable_type == 'Reply'
        NotificationMailer.reply_notification(user, sendable_id).deliver
      end
    end
  end
  handle_asynchronously :notification_deliver
  
  private
  def pay_point
    if sendable_type == 'Question'
      user = Question.find(sendable_id).user
      user.deduct_points(5)
    end
  end
  
  def set_message
    if sendable_type == 'Question'
      self.content = "Please helps me!"
    elsif sendable_type == 'Comment'
      self.content = "You got an answer."
    end
  end
  
  def owner
    if sendable_type == 'Question'
      question = Question.find(sendable_id)
      question.user
    elsif sendable_type == 'Comment'
      comment = Comment.find(sendable_id)
      comment.user
    end
  end
  
  def recipient
    User.find(user_id)
  end
end
