module UserFeedbacksHelper
  def show_type_feedback type
    if (type == "Bug")
      '<span class="label label-important">Bug</span>'.html_safe
    elsif (type == "Enhancement")
      '<span class="label label-info">Enhancement</span>'.html_safe
    end
  end
  
  def close_status close
    if (close)
      '<span class="label label-success">Close</span>'.html_safe
    else
      '<span class="label label-important">Open</span>'.html_safe
    end
  end
end
