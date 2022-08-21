class NotificationsMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications_mailer.confirm_email.subject
  #
  def confirm_email(user)
    @link = user.confirm_email_key.url
    @user = user
    mail(to: user.email, subject: "#{I18n.t('greeting.informal.short')}, #{I18n.t('notifications_mailer.confirm_email.subject')}")
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications_mailer.forgot_password.subject
  #
  def forgot_password
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
