# == Schema Information
#
# Table name: questions
#
#  id               :integer          not null, primary key
#  title            :string(255)
#  content          :text
#  code             :text
#  error            :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :integer
#  anonymous        :boolean
#  fast_answer      :boolean
#  deleted_question :boolean
#

class Question < ActiveRecord::Base
  include PublicActivity::Model
  attr_accessible :anonymous, :code, :content, :error, :title, :user_id, :notifications_attributes, :tag_list, :fast_answer, :deleted_question
  acts_as_taggable
  validates :user_id, presence: true
  #The number of questions per page
  self.per_page = 10
  # tracked 
  # deleted_question should be archive_question
  tracked owner: :owner, params: { title: :title, content: :content, code: :code, error: :error, anonymous: :anonymous, fast_answer: :fast_answer, deleted_question: :deleted_question}
  
  belongs_to :user, :inverse_of => :questions
  has_many :usefuls, :as => :usefulable
  has_many :comments, :inverse_of => :question
  has_and_belongs_to_many :feedbacks
  has_one :good_answer, :inverse_of => :question
  has_many :notifications, :as => :sendable
  accepts_nested_attributes_for :notifications, :reject_if => lambda { |a| a[:user_id].blank? }
  after_save :automatic_feedback
  before_save :tag_tokens
  
  def archive_question
    self.lock!
    self.deleted_question = true
    self.save
  end
  
  def question_owner? user
    User.find(user_id) == user
  end
  
  def tag_tokens()
    ids = tag_list.split(',')
    tagArray = Question.tag_counts.where(:id => ids).map(&:name)
    self.tag_list = tagArray.join(',')
  end
  
  def teacher_notification 
    ta_limitedTime = created_at + 3.hours
    instructor_limitedTime = created_at + 6.hours
    student_limitedTime = created_at + 1.hours
    if fast_answer or self.notifications.where("content = 'Pay 5 points'").count > 0
      student_limitedTime = created_at + 30.minutes
    end
    delay({:run_at => student_limitedTime}).student_notification
    
    if fast_answer
      ta_notification
      instructor_notification
    else
      delay({:run_at => ta_limitedTime}).ta_notification
      delay({:run_at => instructor_limitedTime}).instructor_notification
    end
  end
  
  def self.total_grouped_by_day
    questions = group("date(created_at)").order("date(created_at) ASC").count
  end
  
  private
  def ta_notification
    # It check that there are any answers before sending emails to TAs. 
    # if self.comments.blank?
      users_ta = User.with_role(:ta)
      users_ta.each do |u|
        @attr = { 
          :user_id => u.id,
          :read => false,
        }
        self.notifications.create(@attr)
      end
    # end
  end
  
  def instructor_notification
    # It check that there are any answers before sending emails to instructors. 
    # if self.comments.blank?
      users_instructor = User.with_role(:instructor)
      users_instructor.each do |u|
        @attr = { 
          :user_id => u.id,
          :read => false,
        }
        self.notifications.create(@attr)
      end
    # end
  end
  
  def student_notification 
      users_student = User.with_role(:student)
      users_student.each do |u|
        if u.id != user_id
          @attr = { 
            :user_id => u.id,
            :read => false,
          }
          self.notifications.create(@attr)
        end
      end
  end
  
  def owner
    User.find(user_id)
  end
  
  def automatic_feedback
    if !code.blank?
      enum_code = code.each_line()
      too_long_code_feedback(enum_code)
      code_quality_feedback(enum_code)
    end
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
      where("(title @@ :q or content @@ :q or code @@ :q or error @@ :q) and deleted_question = false", q: query).order("created_at DESC")
    else
      scoped.where("deleted_question = false", q: query).order("created_at DESC")
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
          class_feedback = self.feedbacks.find_by_name(@attr_class_feedback[:name]) 
          if !is_huge_class_feedback && stop_class - start_class > 80 && class_feedback.blank?
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
          method_feedback = self.feedbacks.find_by_name(@attr_method_feedback[:name])
          if !is_huge_method_feedback && stop_method - start_method > 40 && method_feedback.blank?
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
      parameters_feedback = self.feedbacks.find_by_name(@attr_parameters_feedback[:name])
      if !is_huge_parameters_feedback && !parameters_feedback.blank?
        self.feedbacks.delete(parameters_feedback)
      end
    end
  end
end
