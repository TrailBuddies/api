class ApplicationController < ActionController::API
  rescue_from 'ActionController::ParameterMissing' do |exception|
    render json: { errors: exception.to_s }.to_json, status: 422
  end  
end
