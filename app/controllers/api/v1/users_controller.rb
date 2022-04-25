class Api::V1::UsersController < ApplicationController
  before_action :require_token, only: [:me, :logout, :confirm_email, :resend_confirm]
  before_action :admin_only, only: [:index, :destroy]

  # GET /users/me
  def me
    render json: @user
  end

  # POST /users/confirm_email
  def confirm_email
    confirm = ConfirmEmailKey.find_by(key: confirm_email_params[:key])
    if confirm.nil?
      render json: { error: 'Invalid key' }, status: 400
    else
      user = User.find(confirm.user_id)

      if user.id != confirm.user_id && !user.admin
        render json: { error: 'You are unable to confirm using that key' }, status: 403
      else
        user.verified = true
        user.save
        render json: { success: true }, status: 200
      end
    end
  end

  # POST /users/resend_confirm
  def resend_confirm
    if resend_params[:id].exists?
      if @user.admin?
        user = User.find_by(id: resend_params[:id])
        user.create_confirm_email_key
        render json: { success: true }, status: 200
      else
        render json: { error: 'You are unable to resend a confirmation email to another user' }, status: 403
      end
    else
      @user.create_confirm_email_key
      render json: { success: true }, status: 200
    end
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
    @user.remove_token
    render json: { success: true }, status: 200
  end

  # POST /users/register
  def register
    email = register_user_params[:email]
    username = register_user_params[:username]
    unhashed_password = register_user_params[:password]

    if User.find_by(email: email)
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
    user = if params[:id].include?('@')
      User.find_by(email: params[:id])
    else
      User.find_by_id(params[:id]) || User.find_by(username: params[:id])
    end

    if user
      if @user.nil? || !@user.admin
        render json: user.as_json(only: [:id, :username, :created_at]), status: 200
      else
        render json: user
      end
    else
      render json: { error: 'User does not exist' }, status: 404
    end
  end

  # PUT /users/change_password
  def change_password
    if @user.authenticate(change_password_params[:current_password]) || @user.admin
      @user.password = BCrypt::Password.create(change_password_params[:new_password])
      @user.save
      render json: { success: true }, status: 200
    else
      render json: { error: 'Invalid current password' }, status: 403
    end
  end

  # DELETE /users/:id
  def destroy
    user = User.find(params[:id])
    if user
      user.destroy
      render json: { success: true }, status: 200
    else
      render json: { error: 'User does not exist' }, status: 404
    end
  end

  private

  def register_user_params
    params.require(:user).permit(:username, :email, :password).tap do |p|
      p.require(:username)
      p.require(:email)
      p.require(:password)
    end
  end

  def login_user_params
    params.require(:user).permit(:email, :password).tap do |p| 
      p.require(:email)
      p.require(:password)
    end
  end

  def change_password_params
    params.require(:user).permit(:new_password, :current_password).tap do |p|
      p.require(:new_password)
      p.require(:current_password)
    end
  end
  
  def confirm_email_params
    params.require(:confirm_email_key).permit(:key).tap do |p|
      p.require(:key)
    end
  end

  def resend_params
    params.require(:user).permit(:id)
  end
end
