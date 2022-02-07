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
    safe_params = safe_create_params
    if !safe_params
      return
    end

    render json: HikeEvent.create(safe_params.merge(user_id: @user.id))
  end

  private

  def safe_create_params
    duration = parse_duration
    if !duration
      return
    end

    lat = create_params[:lat].to_f
    lng = create_params[:lng].to_f

    if !lat || !lng
      render json: { error: 'Invalid \'lat\' and \'lng\' params. They failed to parse as floating point numbers' }, status: 400 and return
    end

    if lat.to_s.split('.').last.length < 6 || lng.to_s.split('.').last.length < 6
      render json: { error: 'Your latitude and/or longitude coordinates are not precise enough. At least 6 decimal places are required' }, status: 400 and return
    end

    difficulty = create_params[:difficulty].to_i
    if !difficulty || difficulty < 1 || difficulty > 10
      render json: { error: 'Invalid \'difficulty\' param. It failed to parse as an integer or it was out of range (1 <= x <= 10).' }, status: 400 and return
    end

    return {title: create_params[:title], description: create_params[:description], duration: duration, lat: lat, lng: lng, difficulty: difficulty}
  end

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


      if start > finish
        render json: { error: "Start time '#{duration[0]}' is after finish time '#{duration[1]}'" }, status: 400 and return
      end

      return (start..finish)
    else
      render json: { error: 'Invalid duration. duration must be in format: \'#<DateTime>..#<DateTime>\'' }, status: 400
    end
  end
  
  def create_params
    params.require(:hike_event).permit(:title, :description, :duration, :lat, :lng, :difficulty).tap do |event|
      event.require(:title)
      event.require(:description)
      event.require(:duration)
      event.require(:lat)
      event.require(:lng)
      event.require(:difficulty)
    end
  end
end
