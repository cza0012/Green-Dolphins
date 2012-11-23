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
  attr_accessible :anonymous, :code, :content, :error, :title, :user_id, :notifications_attributes, :tag_list
  acts_as_taggable
  validates :user_id, presence: true
  #The number of questions per page
  self.per_page = 10
  
  belongs_to :user, :inverse_of => :questions
  has_many :usefuls, :as => :usefulable
  has_many :comments, :inverse_of => :question
  has_and_belongs_to_many :feedbacks
  has_one :good_answer, :inverse_of => :question
  has_many :notifications, :as => :sendable
  accepts_nested_attributes_for :notifications, :reject_if => lambda { |a| a[:user_id].blank? }
  after_save :automatic_feedback
  
  private
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
    code_feedback = self.feedbacks.find_by_name(@attr_feedback[:name])
    if enum_code.count > 80 && code_feedback.blank?
      self.feedbacks << Feedback.find_or_create_by_name(@attr_feedback)
    else
      unless code_feedback.blank?
        self.feedbacks.delete(code_feedback)
      end
    end
  end

  def self.text_search(query)
    if query.present?
      where("title @@ :q or content @@ :q or code @@ :q or error @@ :q", q: query)
    else
      scoped
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
    class_regex = //
    method_regex = //
    comment_regex = //
    feedback_regex = //
    support_language = false
    parameters_feedback = nil
    
    if enum_code.first.index(/\s*```\s*(java|c++|c#)\s*/i)
      class_regex = /\s+class\s+/i
      method_regex = /\s*\w+(\s+static\s+|\s+)\w+\s+\w+\s*\(/i
      comment_regex = /\/\*|\/\//
      feedback_regex = /\s*\w+(\s+static\s+|\s+)\w+\s+\w+\s*\((\s*\w+\s+\w+(\s*,|\s*)){16,}\s*\)/i
      support_language = true
    end
    
    if support_language
      enum_code.each_with_index{ |item, index|
        # Search for a class keyword and calculate a size of a class
        if  !is_huge_class_feedback && item.index(class_regex)
          count_class++
          if count_class == 1
            start_class = index
          else
            stop_class = index
          end
          if !is_huge_class_feedback && stop_class - start_class > 80 && self.feedbacks.find_by_name(@attr_class_feedback[:name]).blank?
            is_huge_class_feedback = true
            self.feedbacks << Feedback.find_or_create_by_name(@attr_class_feedback[:name])
          else
            start_class = index
          end
        end
        # Search a pattern of a comment
        if !is_no_comments_feedback && item.index(comment_regex)
          is_no_comments_feedback = true
        end
        # Search a pattern of a method
        if  !is_huge_method_feedback && item.index(method_regex)
          count_method++
          if count_method == 1
            start_method = index
          else
            stop_method = index
          end
          if !is_huge_method_feedback && stop_method - start_method > 40 && self.feedbacks.find_by_name(@attr_method_feedback[:name]).blank?
            is_huge_method_feedback = true
            self.feedbacks << Feedback.find_or_create_by_name(@attr_method_feedback)
          else
            start_method = index
          end
          parameters_feedback = self.feedbacks.find_by_name(@attr_parameters_feedback[:name])
          if !is_huge_parameters_feedback && item.index(feedback_regex) && parameters_feedback.blank?
             is_huge_parameters_feedback = true
             self.feedbacks << Feedback.find_or_create_by_name(@attr_parameters_feedback[:name])
          end
        end
      }
      
      class_feedback = self.feedbacks.find_by_name(@attr_class_feedback[:name])    
      if  !is_huge_class_feedback && enum_code.count - start_class > 80 && class_feedback.blank?
        is_huge_class_feedback = true
        self.feedbacks << Feedback.find_or_create_by_name(@attr_class_feedback)
      else
        unless class_feedback.blank?
          self.feedbacks.delete(class_feedback)
        end
      end
      no_comment_feedback = self.feedbacks.find_by_name(@attr_comment_feedback[:name])
      if !is_no_comments_feedback && no_comment_feedback.blank?
          self.feedbacks << Feedback.find_or_create_by_name(@attr_comment_feedback)          
      else
        unless no_comment_feedback.blank?
          self.feedbacks.delete(no_comment_feedback)
        end
      end
      method_feedback = self.feedbacks.find_by_name(@attr_method_feedback[:name])
      if !is_huge_method_feedback && enum_code.count - start_method > 40 && method_feedback.blank?
        is_huge_method_feedback = true
        self.feedbacks << Feedback.find_or_create_by_name(@attr_method_feedback[:name])
      else
        unless method_feedback.blank?
          self.feedbacks.delete(method_feedback)
        end
      end
      if !is_huge_parameters_feedback && !parameters_feedback.blank?
        self.feedbacks.delete(method_feedback)
      end
    end
  end
end
