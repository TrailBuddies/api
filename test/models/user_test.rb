require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user_matievisthekat = users(:matievisthekat)
    @user_test = users(:test)

    # initialize tokens
    @user_matievisthekat.generate_token(true)
    @user_test.generate_token(true)
  end

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

  private

  def token_by_id(id)
    Token.find_by(user_id: id)
  end

end
