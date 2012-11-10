# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  content    :text
#  code       :text
#  error      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  anonymous  :boolean
#  

class Question < ActiveRecord::Base
  attr_accessible :anonymous, :code, :content, :error, :title, :user_id, :notifications_attributes
  
  validates :user_id, presence: true
  
  belongs_to :user, :inverse_of => :questions
  has_many :usefuls, :as => :usefulable
  has_many :comments, :inverse_of => :question
  has_and_belongs_to_many :feedbacks
  has_one :good_answer, :inverse_of => :question
  has_many :notifications, :as => :sendable
  accepts_nested_attributes_for :notifications, :reject_if => lambda { |a| a[:user_id].blank? }
  
  def automatic_feedback
    enum_code = code.each_line()
    too_long_code_feedback(enum_code)
    code_quality_feedback(enum_code)
  end
  
  def too_long_code_feedback(enum_code)
    @attr_feedback = { 
      :name => "A too long code",
      :detail => "Your code is too long. It is hard to read.",
      :photo_link => "www.google.com"
    }
    if enum_code.count > 80
      self.feedbacks << Feedback.find_or_create_by_name!(@attr_feedback)
    end
  end
  
  def code_quality_feedback(enum_code)
    @attr_comment_feedback = { 
      :name => "No comments in a code",
      :detail => "A good code should have comments for description.",
      :photo_link => "www.google.com"
    }
    @attr_class_feedback = { 
      :name => "Large class",
      :detail => "A class is huge. It is hard to be maintananced.",
      :photo_link => "www.google.com"
    }
    @attr_method_feedback = { 
      :name => "Long method",
      :detail => "A method is long. It is hard to be maintananced.",
      :photo_link => "www.google.com"
    }
    @attr_parameters_feedback = { 
      :name => "Too many parameters",
      :detail => "A method is long. It is hard to be maintananced.",
      :photo_link => "www.google.com"
    }
    
    is_huge_class_feedback = false
    is_no_comments_feedback = false
    is_huge_method_feedback = false
    is_huge_parameters_feedback = false
    start_class = 0
    stop_class = 0
    count_class = 0
    start_method = 0
    stop_method = 0
    count_method = 0
    
    enum_code.each_with_index{ |item, index|
      # Search for a class keyword and calculate a size of a class
      if  !is_huge_class_feedback && item.index(/\s+class\s+/i)
        count_class++
        if count_class == 1
          start_class = index
        else
          stop_class = index
        end
        if !is_huge_class_feedback && stop_class - start_class > 80
          is_huge_class_feedback = true
          self.feedbacks << Feedback.find_or_create_by_name!(@attr_class_feedback)
        else
          start_class = index
        end
      end
      # Search a pattern of a comment
      if !is_no_comments_feedback && item.index(/\/\*|\/\//) 
        is_no_comments_feedback = true
      end
      # Search a pattern of a method
      if  !is_huge_method_feedback && item.index(/\s*\w+(\s+static\s+|\s+)\w+\s+\w+\s*\(/i)
        count_method++
        if count_method == 1
          start_method = index
        else
          stop_method = index
        end
        if !is_huge_method_feedback && stop_method - start_method > 40
          is_huge_method_feedback = true
          self.feedbacks << Feedback.find_or_create_by_name!(@attr_method_feedback)
        else
          start_method = index
        end
        
        if !is_huge_parameters_feedback && item.index(/\s*\w+(\s+static\s+|\s+)\w+\s+\w+\s*\((\s*\w+\s+\w+(\s*,|\s*)){16,}\s*\)/i)
           is_huge_parameters_feedback = true
           self.feedbacks << Feedback.find_or_create_by_name!(@attr_parameters_feedback)
        end
      end
    }
    
    if  !is_huge_class_feedback && enum_code.count - start_class > 80 
      is_huge_class_feedback = true
      self.feedbacks << Feedback.find_or_create_by_name!(@attr_class_feedback)
    end
    if !is_no_comments_feedback
      self.feedbacks << Feedback.find_or_create_by_name!(@attr_comment_feedback)
    end
    if !is_huge_method_feedback && enum_code.count - start_method > 40
      is_huge_method_feedback = true
      self.feedbacks << Feedback.find_or_create_by_name!(@attr_method_feedback)
    end
  end
end
