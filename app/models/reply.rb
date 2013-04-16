# == Schema Information
#
# Table name: replies
#
#  id         :integer          not null, primary key
#  content    :text
#  user_id    :integer
#  comment_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Reply < ActiveRecord::Base
  include PublicActivity::Model
  attr_accessible :comment_id, :content, :user_id
  validates :user_id, :comment_id, :content, presence: true
  
  tracked owner: :owner, params: { content: :content, comment_id: :comment_id }
  
  belongs_to :user, :inverse_of => :replies
  belongs_to :comment, :inverse_of => :replies
  has_many :notifications, :as => :sendable, :dependent => :destroy 
  after_save :followrs_notifications
  
  private
  def owner
    User.find(user_id)
  end
  
  def followrs_notifications
    comment = self.comment
    follwers = Reply.where("comment_id = #{comment.id}").select(:user_id).uniq
    
    if user_id != comment.user_id
      self.notifications.create({ user_id: comment.user_id, read: false })
    end
    
    follwers.each  do |f|
      if user_id != f.user_id and f.user_id != comment.user_id
        self.notifications.create({ user_id: f.user_id, read: false })
      end
    end

  end 
end
