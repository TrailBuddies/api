require "test_helper"

class UserTest < ActiveSupport::TestCase
  test 'should fail to authenticate that passwords match' do
    assert_not @user_test.authenticate('baz')
  end

  test 'should successfully authenticate that passwords match' do
    assert @user_test.authenticate('bar')
  end

  test 'should delete the user\'s token' do
    assert_difference('Token.count', -1) do
      res = @user_matievisthekat.remove_token

      assert token_by_id(@user_matievisthekat.id) == nil || res.frozen?
    end
  end

  test 'should remove old token and generate a new one' do
    previous = @user_test.remove_token
    current = @user_test.generate_token

    assert_not_nil current
    assert_not_equal previous.token, current.token
  end

  test 'should overwrite the previous token with a new token' do
    previous = token_by_id(@user_matievisthekat.id)
    current = @user_matievisthekat.generate_token(true)

    assert_not_nil token_by_id(@user_matievisthekat.id)
    assert_not_equal previous.token, current.token
  end

  test 'should create a confirm email key for user' do
    result = @user_test.create_confirm_email_key
    current = @user_test.confirm_email_key

    assert_not_nil result
    assert_not_nil current
    assert_equal result, current
  end

  test 'should remove confirm email key from user' do
    result = @user_test.confirm_email_key.destroy

    assert_not_nil result
    assert result.frozen?
  end

  test 'should remove the current confirm email key and create a new one' do
    previous = @user_test.confirm_email_key
    @user_test.confirm_email_key.destroy
    current = @user_test.create_confirm_email_key

    assert_not_nil confirm_email_key_by_id(@user_test.id)
    assert_not_equal previous.key, current.key
  end

  test 'should return a valid avatar url' do
    avatar_url = @user_matievisthekat.avatar_url
    uri = URI.parse(avatar_url)

    assert uri.scheme == 'https'
    assert uri.host == 'res.cloudinary.com'
    assert uri.path.to_s.starts_with?('/dth4ew8m4/image/upload/')
  end

  private

  def token_by_id(id)
    Token.find_by(user_id: id)
  end

  def confirm_email_key_by_id(id)
    ConfirmEmailKey.find_by(user_id: id)
  end

end
