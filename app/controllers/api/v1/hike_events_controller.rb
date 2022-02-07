class Api::V1::HikeEventsController < ApplicationController
  before_action :require_token, only: [:mine, :create, :destroy, :update]

  def mine
    render json: @user.hike_events
  end

  def index
    render json: HikeEvent.all
  end

  def show
    render json: HikeEvent.find(params[:id])
  end

  def create
    render json: HikeEvent.create(create_params)
  end

  private
  
  def create_params
    params.require(:hike_event).permit(:title, :description, :duration, :lat, :lng, :difficulty, :image_url).tap do |event|
      event.require(:title)
      event.require(:description)
      event.require(:duration)
      event.require(:lat)
      event.require(:lng)
      event.require(:difficulty)
      event.require(:image_url)
    end
  end
end
