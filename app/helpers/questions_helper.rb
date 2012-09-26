module QuestionsHelper
  def anonymous_user? (question)
      question.anonymous == 1 ? 'An anonymous user' : User.find(question.user_id).name
  end
end
