require "test_helper"

class NotificationsMailerTest < ActionMailer::TestCase
  test 'should send email to user' do
    key = @user_matievisthekat.confirm_email_key
    mail = NotificationsMailer.confirm_email(@user_matievisthekat)

    assert_equal "#{I18n.t('greeting.informal.short')}, #{I18n.t('notifications_mailer.confirm_email.subject')}", mail.subject
    assert_equal [@user_matievisthekat.email], mail.to
    assert_nil mail.from.to_s.match(/^\w+\@trailbuddies.club$/)
    assert_includes mail.body, key.url
  end

  # test "forgot_password" do
  #   mail = NotificationsMailer.forgot_password
  #   assert_equal "Forgot password", mail.subject
  #   assert_equal ["to@example.org"], mail.to
  #   assert_equal ["from@example.com"], mail.from
  #   assert_match "Hi", mail.body.encoded
  # end
end
