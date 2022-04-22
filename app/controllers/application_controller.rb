class ApplicationController < ActionController::API
  before_action :user_checks

  include RSAUtil

  def user_checks
    @token = get_current_token
    @user = get_current_user
  end

  def get_current_user
    if @token
      begin
        decoded_token = JWT.decode(@token, OpenSSL::PKey::RSA::new(RSAUtil::Keys::priv, ENV['PASSPHRASE']), true, { algorithm: 'RS256' })
      rescue JWT::DecodeError
      end

      if decoded_token == nil
        render json: { error: 'Invalid token' }, status: :unauthorized
      else
        subject = decoded_token[0]['sub']

        token = Token.find_by(user_id: subject.split('.')[0])
        user = if !token.nil?
          User.find(token.user_id)
        end

        if !token || !user || subject != user.id
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
    end
  end

  def admin_only
    require_token
    if !@user.admin
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
      JWT.decode(token, OpenSSL::PKey::RSA::new(RSAUtil::Keys::pub, ENV['PASSPHRASE']), true, { algorithm: 'RS256' })
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
