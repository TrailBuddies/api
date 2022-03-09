# Preview all emails at http://localhost:3000/rails/mailers/notifications_mailer
class NotificationsMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/notifications_mailer/confirm_email
  def confirm_email
    NotificationsMailer.confirm_email(User.find_by(username: 'test'))
  end

  # Preview this email at http://localhost:3000/rails/mailers/notifications_mailer/forgot_password
  def forgot_password
    NotificationsMailer.forgot_password
  end

end
