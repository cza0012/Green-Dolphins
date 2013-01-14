module UsersHelper
  def user_role user
    role = 'Student'
    expert = false
    user_roles = user.roles
    user_roles.each do |r|
      if r.name == 'admin'
        return role = 'Admin'
      elsif r.name == 'ta'
        return role = 'TA'
      elsif r.name == 'instructor'
        return role = 'Instructor'
      elsif r.name == 'expert'
        expert = true
      end
    end
    if expert
      role = 'Expert student'
    else
      role
    end
  end
  
  def rank_user( rank, all_user, user )
    if user == current_user
      'info'
    elsif ((all_user*10.0)/100).ceil >= rank
      'success'
    elsif ((all_user*90.0)/100).floor <= rank
      'warning'
    end
  end
  
  def answers_questions_chart
    answers_by_day = Comment.total_grouped_by_day   
    questions_by_day = Question.total_grouped_by_day   
    start_date = Date.parse(answers_by_day.first[0])
    answers_by_day = to_cumulative(start_date, answers_by_day)
    questions_by_day = to_cumulative(start_date, questions_by_day)
    
    previous_date_answer = start_date
    previous_date_question = start_date
    (start_date..Date.today).reject {|date| answers_by_day[date.to_s].blank? and questions_by_day[date.to_s].blank?}.map do |date|
        if !answers_by_day[date.to_s].blank? and !questions_by_day[date.to_s].blank?
          previous_date_answer = date
          previous_date_question = date
          {
                created_at: date,
                total_answers: answers_by_day[date.to_s],
                total_questions: questions_by_day[date.to_s]
          }
      elsif answers_by_day[date.to_s].blank? and !questions_by_day[date.to_s].blank?
          previous_date_question = date
          {
                created_at: date,
                total_answers: answers_by_day[previous_date_answer.to_s],
                total_questions: questions_by_day[date.to_s]
          }
      elsif !answers_by_day[date.to_s].blank? and questions_by_day[date.to_s].blank?
          previous_date_answer = date
          {
                created_at: date,
                total_answers: answers_by_day[date.to_s],
                total_questions: questions_by_day[previous_date_question.to_s]
          }
      else
          {
                created_at: date,
                total_answers: answers_by_day[previous_date_answer.to_s],
                total_questions: questions_by_day[previous_date_question.to_s]
          }
      end
    end
  end
  
  def user_activities
    [ 
      {label: "Answers", value: @number_answers}, 
      {label: "Questions", value: @number_questions}, 
      {label: "Useful", value: @number_usefuls},
      {label: "Replies", value: @number_replies},
    ]
  end
  
  def answer_performance
    users_answers = Comment.group("user_id").count()
    max_answers = users_answers.max_by{|row| row[1]}
    average_answers = average_hash(users_answers)
  end
  
  def to_cumulative(start_date, hash_data)
    cumulative_answers = 0
    (start_date..Date.today).each { |date| 
      if !hash_data[date.to_s].blank?
        cumulative_answers = cumulative_answers + hash_data[date.to_s]
        hash_data[date.to_s] = cumulative_answers
      end
    }
    hash_data
  end
  
  def average_hash(hash)
    sum = 0
    n = hash.size
    hash.each do |data|
      sum = sum + data[1]
    end
    sum.to_f / n
  end
  
  def stack_progress_bar(current_data, average_data, maximum)
    average = average_data/maximum.to_f * 100
    current = current_data/maximum.to_f * 100
    if average < current
      "<div class='progress'>
        <div class='bar bar-warning' style='width: #{average}%;'>#{average_data.to_int}</div>
        <div class='bar' style='width: #{current-average}%;'>#{current_data}</div>
      </div>".html_safe
    elsif average > current

      "<div class='progress'>
        <div class='bar' style='width: #{current}%;'>#{current_data}</div>
        <div class='bar bar-warning' style='width: #{average-current}%;'>#{average_data.to_int}</div>
      </div>".html_safe
    else
      "<div class='progress'>
        <div class='bar bar-warning' style='width: #{average}%;'>#{average_data.to_int}</div>
        <div class='bar' style='width: #{current}%;'>#{current_data}</div> #{maximum}
      </div>".html_safe
    end
  end
  
  def question_statistic
    answered_questions = Question.joins(:comments).where(:questions => {:deleted_question => false}, :comments => {:deleted_comment => false}).uniq
    progress_result = (answered_questions.to_a.size/@exist_questions.to_f*100).round(2)
    "<div class='progress'>
      <div class='bar bar-success' style='width: #{progress_result}%;'>#{answered_questions.size}</div>
    </div>".html_safe
  end
end
