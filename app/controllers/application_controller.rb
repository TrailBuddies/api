class ApplicationController < ActionController::API
  def authenticate_user
    token = request.headers['HTTP_AUTHORIZATION']
    if !token || !is_valid_token(token)
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
      decoded_token = JWT.decode token, Rails.configuration.x.oauth.jwt_secret, true
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
