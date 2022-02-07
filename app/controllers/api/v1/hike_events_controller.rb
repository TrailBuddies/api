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
    duration = create_params[:duration].split('..')
    unless duration.length != 2
      start = Time.zone.parse(duration[0])
      if !start
        return render json: { error: "Invalid start time '#{duration[0]}'" }, status: 400
      end

      finish = Time.zone.parse(duration[1])
      if !finish
        return render json: { error: "Invalid finish time '#{duration[1]}'" }, status: 400
      end

      render json: { done: true } #HikeEvent.create(create_params)
    else
      render json: { error: 'Invalid duration. duration must be in format: \'#<DateTime>..#<DateTime>\'' }, status: 400
    end
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
