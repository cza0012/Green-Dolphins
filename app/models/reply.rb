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
  attr_accessible :comment_id, :content, :user_id
  validates :user_id, :comment_id, :content, presence: true
  
  belongs_to :user, :inverse_of => :replies
  belongs_to :comment, :inverse_of => :replies
end
