class Api::V1::HikeEventsController < ApplicationController
  before_action :require_token, only: [:mine]
  
  def mine
    render json: @user.hike_events
  end
end
