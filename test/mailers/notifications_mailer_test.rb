require "test_helper"

class NotificationsMailerTest < ActionMailer::TestCase
  test "confirm_email" do
    user = users(:matievisthekat)
    link = confirm_email_keys(:matievisthekat_user_confirm_email_key)
    mail = NotificationsMailer.confirm_email(user)

    assert_equal "#{I18n.t('greeting.informal.short')}, #{I18n.t('notifications_mailer.confirm_email.subject')}", mail.subject
    assert_equal [user.email], mail.to
    assert_nil mail.from.to_s.match(/^\w+\@trailbuddies.club$/)
    assert_includes mail.body, link.url
  end

  # test "forgot_password" do
  #   mail = NotificationsMailer.forgot_password
  #   assert_equal "Forgot password", mail.subject
  #   assert_equal ["to@example.org"], mail.to
  #   assert_equal ["from@example.com"], mail.from
  #   assert_match "Hi", mail.body.encoded
  # end
end
