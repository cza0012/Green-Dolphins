# == Schema Information
#
# Table name: good_answers
#
#  id          :integer          not null, primary key
#  question_id :integer
#  comment_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class GoodAnswer < ActiveRecord::Base
  include PublicActivity::Model
  attr_accessible :question_id, :comment_id
  validates_uniqueness_of :question_id, :comment_id
  validates_presence_of :question_id, :comment_id
  
  tracked owner: :owner,recipient: :recipient, params: { question_id: :question_id, comment_id: :comment_id }
  
  belongs_to :question, :inverse_of => :good_answer
  belongs_to :comment, :inverse_of => :good_answer 
  
  private
  def owner
    question = Question.find(question_id)
    question.user
  end
  
  def recipient
    comment = Comment.find(comment_id)
    comment.user
  end
end
