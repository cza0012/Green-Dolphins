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
  
  tracked owner: Proc.new{ |controller, model| controller.current_user }, recipient: Proc.new{|controller, model| model.user}, params: { content: :content, read: :read, sendable_id: :sendable_id, sendable_type: :sendable_type }
  
  belongs_to :user, :inverse_of => :notifications
  belongs_to :sendable, :polymorphic => true 
  after_validation :set_message
  
  def read_notification
    self.lock!
    self.read = true
    self.save
  end
  
  private
  def set_message
    user = User.find(user_id)
    if sendable_type == 'Question'
      self.content = "Please helps me!"
    elsif sendable_type == 'Comment'
      self.content = "You got an answer."
    end
  end
end
