class NotificationMailer < ActionMailer::Base
  default from: "no-reply@auburn.edu"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.expert_notification.subject
  #
  def expert_notification(user, sendable_id)
    attachments["greendolphin_logo.png"] = File.read("#{Rails.root}/app/assets/images/greendolphin_logo.png")
    @user = user
    @question = Question.find(sendable_id)
    if (@user.has_role?(:ta) || @user.has_role?(:instructor)) && @question.fast_answer
      mail to: user.email, subject: "[Need a Fast Answer] Your friend asked you a question."
    else
      mail to: user.email, subject: "Your friend asked you a question."
    end
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.comment_notification.subject
  #
  def comment_notification(user, sendable_id)
    attachments["greendolphin_logo.png"] = File.read("#{Rails.root}/app/assets/images/greendolphin_logo.png")
    @user = user
    @question = Comment.find(sendable_id).question
    
    mail to: user.email, subject: "Your friend answered your question"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.reply_notification.subject
  #
  def reply_notification(user, sendable_id)
    attachments["greendolphin_logo.png"] = File.read("#{Rails.root}/app/assets/images/greendolphin_logo.png")
    @user = user 
    @reply = Reply.find(sendable_id)
    @question = @reply.comment.question
    
    mail to: @user.email, subject: "Your friend replied your comment."
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.good_answer_notification.subject
  #
  def good_answer_notification(user, sendable_id)
    attachments["greendolphin_logo.png"] = File.read("#{Rails.root}/app/assets/images/greendolphin_logo.png")
    @user = user 
    @good_answer = GoodAnswer.find(sendable_id)
    @question = @good_answer.question
    
    mail to: @user.email, subject: "Your answer was selected to be the best answer."
  end
  
  def useful_notification(user, sendable_id)
    attachments["greendolphin_logo.png"] = File.read("#{Rails.root}/app/assets/images/greendolphin_logo.png")
    @user = user 
    @useful = Useful.find(sendable_id)
    @question = @useful.useful_parent_question
    
    mail to: @user.email, subject: "Your friend votes your response to be useful."
  end
end
