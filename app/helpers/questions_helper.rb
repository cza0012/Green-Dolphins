module QuestionsHelper
  def good_answer? (good_answer, comment)
      if ! good_answer.nil?
        good_answer.comment_id == comment.id ? highlight('Here!', 'Here!') : ''
      end
  end
end
