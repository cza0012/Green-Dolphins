class Notification < ActiveRecord::Base
  attr_accessible :content, :read, :sender_id, :user_id
  belongs_to :user, :inverse_of => :notifications
end
