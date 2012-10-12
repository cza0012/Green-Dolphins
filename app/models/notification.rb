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
  attr_accessible :content, :read, :sender_id, :user_id
  belongs_to :user, :inverse_of => :notifications
  belongs_to :sendable, :polymorphic => true
end
