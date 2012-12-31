# == Schema Information
#
# Table name: usefuls
#
#  id              :integer          not null, primary key
#  usefulable_id   :integer
#  usefulable_type :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :integer
#

class Useful < ActiveRecord::Base
  include PublicActivity::Model
  attr_accessor :parent
  attr_accessible :usefulable_type, :user_id
  
  validates :user_id, presence: true
  
  tracked owner: :owner, params: { usefulable_id: :usefulable_id, usefulable_type: :usefulable_type }
  
  belongs_to :usefulable, :polymorphic => true
  belongs_to :user, :inverse_of => :usefuls
  
  def self.create_useful(params)
    if params[:type] == "Comment"
      @usefulable_obj = Comment.find(params[:comment_id])
    elsif params[:type] == "Question"
      @usefulable_obj = Question.find(params[:question_id])
    end
  end
  
  def useful_parent
    if usefulable_type == "Comment"
      @usefulable_obj = Comment.find(usefulable_id)
    elsif usefulable_type == "Question"
      @usefulable_obj = Question.find(usefulable_id)
    end
  end
  
  def useful_parent_question
    if usefulable_type == "Comment"
      @usefulable_obj = Comment.find(usefulable_id).question
    elsif usefulable_type == "Question"
      @usefulable_obj = Question.find(usefulable_id)
    end
  end
  
  private 
  def owner
    User.find(user_id)
  end
end
