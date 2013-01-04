module QuestionsHelper
  
  def waiting_bar question, comment, ta_limit_time, instructor_limit_time
    user = User.find(comment.user_id)
    if user.has_role?(:ta)
      full_waitingTime = ta_limit_time.to_time - comment.created_at.to_time
      time_left = ta_limit_time.to_time - Time.now 
      progress = 100 - (time_left / full_waitingTime * 100)
      "<div class=\"bar\" style=\"width: #{progress}%;\"></div>".html_safe
    elsif user.has_role?(:instructor)
      full_waitingTime = instructor_limit_time.to_time - comment.created_at.to_time
      time_left = instructor_limit_time - Time.now 
      progress = 100 - (time_left / full_waitingTime * 100)
      "<div class=\"bar\" style=\"width: #{progress}%;\"></div>".html_safe
    end
  end
  
  def show_time question, comment, ta_limit_time, instructor_limit_time
    user = User.find(comment.user_id)
    if user.has_role?(:ta)
      "<p>This comment will be displayed at <strong>#{ta_limit_time.in_time_zone('Central Time (US & Canada)').strftime("%k:%M %B %d, %Y")}</strong></P>".html_safe
    elsif user.has_role?(:instructor)
      "<p>This comment will be displayed at <strong>#{instructor_limit_time.in_time_zone('Central Time (US & Canada)').strftime("%k:%M %B %d, %Y")}</strong></P>".html_safe
    end
  end
  
end
