module QuestionsHelper
  def best_answer? (good_answer, comment)
      if ! good_answer.nil?
        good_answer.comment_id == comment.id ? highlight('The best answer here!', 'here!') : ''
      end
  end
end
