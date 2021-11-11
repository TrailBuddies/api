class Api::V1::UsersController < ApplicationController
  before_action :require_token, only: [:me]

  # GET /users/me
  def me
    render json: @user
  end

  # POST /users/login
  def login
    user = User.find_by(email: login_user_params[:email])
    if user && user.authenticate(login_user_params[:password])
      render json: user
    else
      render json: { error: 'Invalid email password combination' }, status: 400
    end
  end

  # POST /users/logout
  def logout

  end

  # POST users/register
  def register
    
  end

  # GET /users
  def index
    users = User.all
    render json: users
  end

  # GET /users/:id
  def show
    user = User.find(params[:id])
    token = JWT.encode({ user_id: user.id }, Rails.configuration.x.oauth.jwt_secret, 'HS256')
    render json: user
  end

  # POST /users
  def create
    user = User.new(create_user_params)
    if user.save
      render json: user
    else
      render json: { error: 'Failed to create user' }, status: 400
    end
  end

  # DELETE /users/:id
  def destroy
    user = User.find(params[:id])
    if user
      user.destroy
      render json: { success: true }, status: 200
    else
      render json: { error: 'User does not exist' }, status: 400
    end
  end

  private

  def create_user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def login_user_params
    params.require(:user).permit(:email, :password)
  end
end
