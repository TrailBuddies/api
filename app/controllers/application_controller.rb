class ApplicationController < ActionController::API
  before_action :user_checks

  def user_checks
    @token = get_current_token
    @user = get_current_user
  end

  def get_current_user
    if @token
      decoded_token = JWT.decode(@token, OpenSSL::PKey::RSA::new(File.read('config/rsa/public.pem'), ENV['PASSPHRASE']), true, { algorithm: 'RS256' })
      puts decoded_token
    end
  end

  def get_current_token
    request.headers['Authorization']
  end

  def require_token
    if !@token || !is_valid_token(token)
      render json: { error: 'No valid token provided in the \'Authorization\' header' }, status: :forbidden
    end
  end

  private
  def is_valid_token(token)
    unless token
      return false
    end

    token.gsub!('Bearer ','')
    begin
      JWT.decode(token, OpenSSL::PKey::RSA::new(File.read('config/rsa/public.pem'), ENV['PASSPHRASE']), true, { algorithm: 'RS256' })
      return true
    rescue JWT::DecodeError
      Rails.logger.warn 'Error decoding the JWT: ' + e.to_s
    end
    false
  end

  rescue_from 'ActionController::ParameterMissing' do |exception|
    render json: { errors: exception.to_s }.to_json, status: 422
  end  
end
