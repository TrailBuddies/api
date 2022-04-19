class ConfirmJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    NotificationsMailer.confirm_email(user).deliver_now
  end
end
