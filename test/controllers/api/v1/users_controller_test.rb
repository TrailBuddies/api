require "test_helper"

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @current_user = users(:test)
    @current_user_token = tokens(:test_user_token)

    @admin_user = users(:matievisthekat)
    @admin_user_token = tokens(:matievisthekat_token)
  end

  test "should fail to get index" do
    get '/api/v1/users', as: :json

    assert_response :forbidden
  end

  test 'should successfully get index' do
    get '/api/v1/users', headers: {
      Authorization: "Bearer #{@admin_user_token.token}"
    }, as: :json

    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count", 1) do
      post '/api/v1/users/register', params: {
        user: {
          username: 'test_user',
          email: 'test@example.net',
          password: 'test.password'
        }
      }, as: :json
    end

    assert_response :created
  end

  test "should show the current user" do
    get '/api/v1/users/me', headers: {
      Authorization: "Bearer #{@current_user_token.token}"
    }, as: :json

    assert_response :success
  end

  # test "should update api_v1_user" do
  #   patch api_v1_user_url(@api_v1_user), params: { api_v1_user: {  } }, as: :json
  #   assert_response :success
  # end

  test "should try but fail to destroy the current user" do
    delete "/api/v1/users/#{@current_user.id}", headers: {
      Authorization: "Bearer #{@current_user_token.token}"
    }, as: :json

    assert_response :forbidden
  end

  test "should successfully destroy the current user" do
    assert_difference('User.count', -1) do
      delete "/api/v1/users/#{@current_user.id}", headers: {
        Authorization: "Bearer #{@admin_user_token.token}"
      }, as: :json

      assert_response :success
    end
  end
end
