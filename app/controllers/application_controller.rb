class ApplicationController < ActionController::API
  before_action :user_checks

  include RSAUtil
  include JWTUtil

  def user_checks
    @token = get_current_token
    @user = get_current_user
  end

  def get_current_user
    if @token
      begin
        decoded_token = JWTUtil::decode(@token)
      rescue JWT::DecodeError
      end

      if decoded_token == nil
        render json: { error: 'Invalid token' }, status: :unauthorized
      else
        subject = decoded_token[0]['sub']

        token = Token.find_by(user_id: subject.split('.')[0])
        user = unless token.nil?
                 User.find(token.user_id)
               end

        if !token || !user || subject.split('.')[0] != user.id
          render json: { error: "Invalid token" }, status: :unauthorized
        else
          return user
        end
      end
    end
  end

  def get_current_token
    request.headers['Authorization'].sub!('Bearer ', '') if request.headers['Authorization']
  end

  def require_token
    if !@token || !is_valid_token(@token)
      render json: { error: 'No valid token provided in the \'Authorization\' header' }, status: :forbidden
      return false
    end
    true
  end

  def admin_only
    has_token = require_token
    if has_token && (@user.nil? || !@user.admin)
      render json: { error: 'Only admins can do that' }, status: :unauthorized
    end
  end

  private
  def is_valid_token(token)
    unless token
      return false
    end

    token.sub!('Bearer ','')
    begin
      JWTUtil::decode(token)
      return true
    rescue JWT::DecodeError
      Rails.logger.warn 'Error decoding the JWT: ' + e.to_s
    end
    false
  end

  rescue_from ActionController::ParameterMissing do |exception|
    render json: { errors: exception.to_s }.to_json, status: 422
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { errors: exception.to_s }.to_json, status: 404
  end
end
