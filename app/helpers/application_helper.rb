module ApplicationHelper
  def anonymous_user? (question_or_answer)
      question_or_answer.anonymous == 1 ? 'An anonymous user' : User.find(question_or_answer.user_id).name
  end
end
