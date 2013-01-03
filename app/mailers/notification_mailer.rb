class NotificationMailer < ActionMailer::Base
  default from: "no-reply@auburn.edu"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.expert_notification.subject
  #
  def expert_notification(user, sendable_id)
    @user = user
    @question = Question.find(sendable_id)
    
    mail to: user.email, subject: "Your friend asked you a question."
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.comment_notification.subject
  #
  def comment_notification(user, sendable_id)
    @user = user
    @question = Comment.find(sendable_id).question
    
    mail to: user.email, subject: "Your friend answered your question"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.reply_notification.subject
  #
  def reply_notification
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.good_answer_notification.subject
  #
  def good_answer_notification
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
