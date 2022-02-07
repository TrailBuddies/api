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
    duration = parse_duration
    if !duration
      return
    end

    render json: { done: true }
  end

  private

  def parse_duration
    duration = create_params[:duration].split('..')
    unless duration.length != 2
      start = Time.zone.parse(duration[0])
      if !start
        render json: { error: "Invalid start time '#{duration[0]}'" }, status: 400 and return
      end

      finish = Time.zone.parse(duration[1])
      if !finish
        render json: { error: "Invalid finish time '#{duration[1]}'" }, status: 400 and return
      end

      return [start, finish]
    else
      render json: { error: 'Invalid duration. duration must be in format: \'#<DateTime>..#<DateTime>\'' }, status: 400
    end
  end
  
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
