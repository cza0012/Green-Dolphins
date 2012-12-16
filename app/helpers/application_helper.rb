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
  
  def anonymous_user?(question_or_answer)
      question_or_answer.anonymous == true ? 'An anonymous user' : User.find(question_or_answer.user_id).name
  end
  
  def tag_questions_link(tag, css_class)
    link_to tag.name, questions_tags_path(tag.name), class: css_class
  end
  
  def tag_users_link(tag, css_class)
    link_to tag.name, users_tags_path(tag.name), class: css_class
  end
  
  def question_owner_link(question)
    link_to User.find(question.user_id).name, question.user
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
    link_to User.find(comment.user_id).name, comment.user
  end
  
  def question_of_comment_link(comment)
    link_to Question.find(comment.question_id).title, comment.question
  end
end
