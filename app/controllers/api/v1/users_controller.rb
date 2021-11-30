class Api::V1::UsersController < ApplicationController
  before_action :require_token, only: [:me, :destroy]

  # GET /users/me
  def me
    render json: @user
  end

  # POST /users/login
  def login
    user = User.find_by(email: login_user_params[:email])
    if user && user.authenticate(login_user_params[:password])
      token = user.generate_token(true)
      render json: { user: user, auth: token }
    else
      render json: { error: 'Invalid email password combination' }, status: 400
    end
  end

  # POST /users/logout
  def logout

  end

  # POST users/register
  def register
    email = register_user_params[:email]
    username = register_user_params[:username]
    unhashed_password = register_user_params[:password]

    if email.blank? || username.blank? || unhashed_password.blank?
      return render json: { error: 'One or more fields are blank' }, status: 400
    elsif User.find_by(email: email)
      return render json: { error: 'Email already in use' }, status: 400
    elsif User.find_by(username: username)
      return render json: { error: 'Username already in use' }, status: 400
    end

    password = BCrypt::Password.create(unhashed_password)

    begin
      user = User.create(email: email, username: username, password: password)
      token = user.generate_token(true)
      render json: { user: user, auth: token }
    rescue => exception
      render json: { error: exception.message }, status: 400
    end
  end

  # GET /users
  def index
    users = User.all
    render json: users
  end

  # GET /users/:id
  def show
    user = User.find(params[:id])
    render json: user
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

  def register_user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def login_user_params
    params.require(:user).permit(:email, :password)
  end
end
