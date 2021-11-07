class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user, only: [:me, :index, :show, :destroy]

  def me
    render json: current_user
  end

  # GET /users
  def index
    @users = User.all
    render json: @users
  end

  # GET /users/:id
  def show
    @user = User.find(params[:id])
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user
    else
      render json: { error: 'Failed to create user' }, status: 400
    end
  end

  # DELETE /users/:id
  def destroy
    @user = User.find(params[:id])
    if @user
      @user.destroy
      render json: { success: true }, status: 200
    else
      render json: { error: 'User does not exist' }, status: 400
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end
