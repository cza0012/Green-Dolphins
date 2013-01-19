module ApplicationHelper
  class HTMLwithPygments < Redcarpet::Render::HTML
    def block_code(code, language)
      sha = Digest::SHA1.hexdigest(code)

      if Pygments::Lexer.find_by_alias(language).blank?
        language = nil
      else
        if !language.blank?
          language = language.downcase
        end
      end
      Rails.cache.fetch ["code", language, sha].join('-') do
        Pygments.highlight(code, lexer: language)
      end
    end
  end

  def markdown(text)
    renderer = HTMLwithPygments.new(hard_wrap: true, filter_html: true)
    options = {
      autolink: true,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      lax_html_blocks: true,
      strikethrough: true,
      superscript: true
    }
    Redcarpet::Markdown.new(renderer, options).render(text).html_safe
  end
  
  def anonymous_user(question_or_answer)
      question_or_answer.anonymous == true ? 'An anonymous user' : link_to(question_or_answer.user.name, question_or_answer.user) 
  end
  
  def tag_questions_link(tag, css_class)
    link_to tag.name, questions_tags_path(tag.name), class: css_class
  end
  
  def tag_users_link(tag, css_class)
    link_to tag.name, users_tags_path(tag.name), class: css_class
  end
  
  def question_owner_link(question)
    link_to question.user.name, question.user
  end
  
  def question_tag_list(question)
    raw question.tag_list.map { |t| link_to t, questions_tags_path(t), class: "label" }.join(' ')
  end
  
  def user_tag_list(user)
    raw user.tag_list.map { |t| link_to t, users_tags_path(t), class: "label" }.join(' ')
  end
  
  def teacher?(user)
    if user.has_role?(:ta) || user.has_role?(:instructor)
      true
    else
      false
    end
  end
  
  def current_user_owner?(user)
    current_user == user
  end
  
  def comment_owner_link(comment)
    link_to comment.user.name, comment.user
  end
  
  def question_of_comment_link(comment)
    question = comment.question
    if !question.deleted_question
      link_to question.title, question
    else
      question.title
    end
  end
  
  def question_link(question)
    if !question.deleted_question
      link_to question.title, question
    else
      question.title
    end
  end
  
  def useful_question_link(useful_array, useful_object)
    if useful_array.blank?
      link_to '<i class="icon-thumbs-up"></i> Useful question'.html_safe, useful_path(id: '', type: 'Question', question_id: useful_object.id, useful: {user_id: current_user.id}), method: :post, class: 'btn btn-small', :'data-toggle' => "button", id: "useful_question_button", remote: true, data: {'original-title'=> "+2 points"}, :rel => "tooltip nofollow"
    else
      link_to '<i class="icon-thumbs-up"></i> Useful question'.html_safe, useful_array.first, method: :delete, class: 'btn btn-small active', :'data-toggle' => "button", id: "useful_question_button", remote: true, data: {'original-title'=> "-2 points"}, :rel => "tooltip nofollow"
    end
  end
  
  def best_answer(good_answer, comment)
      if ! good_answer.blank?
        if good_answer.comment_id == comment.id
          '<button type="button" class="btn btn-success btn-small" disabled="disabled"><i class="icon-ok icon-white"></i> Best answer</button>'.html_safe
        end
      end
  end
  
  def good_answer_button(good_answer, comment)
    if good_answer.blank?
       link_to '<i class="icon-ok"></i> Best answer'.html_safe, good_answer_path( id: '' ,good_answer: {question_id: @question.id, comment_id: comment.id} ), method: :post, class: 'btn btn-small good-answer', id: "good_answer_button_#{comment.id}", data: {'original-title'=> "+5 points"}, :rel => "tooltip nofollow", remote: true
    end 
  end
  
  def useful_comment_link(useful_array, useful_object)
    if useful_array.blank?
      link_to '<i class="icon-thumbs-up"></i> Useful comment'.html_safe, useful_path(id: '', type: 'Comment', comment_id: useful_object.id, useful: {user_id: current_user.id}), method: :post, class: 'btn btn-small', :'data-toggle' => "button", id: "useful_comment_button_#{useful_object.id}", remote: true, data: {'original-title'=> "+2 points"}, :rel => "tooltip nofollow"
    else
      link_to '<i class="icon-thumbs-up"></i> Useful comment'.html_safe, useful_array.first, method: :delete, class: 'btn btn-small active', :'data-toggle' => "button", id: "useful_comment_button_#{useful_object.id}", remote: true, data: {'original-title'=> "-2 points"}, :rel => "tooltip nofollow"
    end
  end
  
  def current_notifications
    @current_notifications = Notification.where('user_id = ? AND created_at > ? AND read = false', current_user.id, 1.weeks.ago)
  end
  
  def good_answer? question
    no_good_answer = true
    if !question.good_answer.blank?
        comment = question.good_answer.comment
        if !comment.deleted_comment
          no_good_answer = false
        end
    end
    if no_good_answer
      if question.comments.where('deleted_comment = false').blank?
        '<span class="label label-important"><i class= "icon-exclamation-sign icon-white"></i> Answers</span>'.html_safe
      else
        '<span>Answers</span>'.html_safe
      end
    else
      '<span class="label label-success""><i class= "icon-ok icon-white"></i> Answers</span>'.html_safe
    end
  end
  
  def reply_user(reply)
      link_to(reply.user.name, reply.user) 
  end
  
  def question_content(question)
    if question.deleted_question
      '<p>The question was <strong>deleted!</strong></p>'.html_safe
    else
      raw question.content
    end
  end
  
  def comment_content(comment)
    if comment.deleted_comment
      '<p>The comment was <strong>deleted!</strong></p>'.html_safe
    else
      raw comment.content
    end
  end
  
  def number_of_answers question
    question.comments.where('hidden = false and deleted_comment = false').count
  end
  
  def user_gravatar(user, size)
    gravatar_id = Digest::MD5::hexdigest(user.email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}?s=#{size}"
  end
  
  def anonymous_user_gravatar(question_or_answer)
      if question_or_answer.anonymous == false
        user = User.find(question_or_answer.user_id)
        image_tag user_gravatar(user, 34) 
      end
  end
end
