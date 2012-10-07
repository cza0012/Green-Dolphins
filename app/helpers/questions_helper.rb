module QuestionsHelper
  def best_answer(good_answer, comment)
      if ! good_answer.nil?
        good_answer.comment_id == comment.id ? highlight('The best answer here!', 'here!') : ''
      end
  end
  
  def good_answer_button(good_answer, comment)
    if good_answer.blank?
       link_to 'The best answer', good_answer_path( id: '' ,good_answer: {question_id: @question.id, comment_id: comment.id} ), method: :post
    end 
  end
  
end
