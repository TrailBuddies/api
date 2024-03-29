class Api::V1::HikeEventsController < ApplicationController
  before_action :require_token, only: [:current_user, :create, :destroy, :update, :join, :leave, :confirm]

  include StrUtil

  def current_user
    render json: @user.hike_events
  end

  def show_for_user
    user = User.find(params[:id])
    render json: user.hike_events
  end

  def index
    render json: HikeEvent.all.order(created_at: :desc).map{ |e| e.as_json(methods: :image_url) }
  end

  def show
    render json: HikeEvent.find(params[:id]).as_json(methods: :image_url)
  end

  def create
    params = safe_params(create_params)
    if !params
      return
    end
    
    render json: HikeEvent.create(params.merge(user_id: @user.id)).as_json(methods: :image_url)
  end

  def join
    event = HikeEvent.find(params[:id])
    if event.user_id == @user.id
      render json: { error: 'You can\'t join your own event' }, status: 400 and return
    elsif event.users_unconfirmed.include?(@user.id)
      render json: { error: 'You have already requested to join this event' }, status: 400 and return
    elsif event.users.include?(@user.id)
      render json: { error: 'You have already joined this event' }, status: 400 and return
    end

    event.users_unconfirmed.push(@user.id)
    event.save

    render json: event
  end

  def leave
    event = HikeEvent.find(params[:id])

    if event.users_unconfirmed.include?(@user.id)
      event.users_unconfirmed.delete_at(event.users_unconfirmed.index(@user.id))
    elsif event.users.include?(@user.id)
      event.users.delete_at(event.users.index(@user.id))
    else
      render json: { error: 'You haven\'t requested to join this event so you obviously cant\'t leave it dumbass' }, status: 400 and return
    end
    
    event.save
    render json: { success: true }, status: 200 and return
  end

  def confirm
    event = HikeEvent.find(params[:id])
    user = User.find(params[:uid])
    
    if event.users_unconfirmed.include?(user.id)
      event.users_unconfirmed.delete_at(event.users_unconfirmed.index(user.id))
      event.users.push(user.id)
      event.save

      render json: { success: true }, status: 200
    elsif event.users.include?(user.id)
      render json: { error: 'This user is already confirmed for this event' }, status: 400 and return
    else
      render json: { error: 'This user has not requested to join this event. Wait for them to request before confirming them' }, status: 400 and return
    end
  end

  def destroy
    event = HikeEvent.find(params[:id])
    if event.user_id != @user.id && !@user.admin
      render json: { error: 'You do not own that event. So you obviously can\'t delete it dumbass' }, status: 403 and return
    end

    event.destroy
    render json: { success: true }, status: 200
  end

  def update
    event = HikeEvent.find(params[:id])
    if event.user_id != @user.id && !@user.admin
      render json: { error: 'You do not own that event. So you obviously can\'t update it' }, status: 403
    end

    defaults = {:title=>event.title, :description=>event.description, :duration=>event.duration, :lat=>event.lat, :lng=>event.lng, :difficulty=>event.difficulty}
    params = safe_params(defaults.merge(fix_params(update_params)))
    if !params
      return
    end


    event.update(params)
    render json: event, status: 200
  end

  private

  def safe_params (p)
    duration = parse_duration(p)
    if !duration
      return
    end

    lat_valid = StrUtil::is_valid_float?(p[:lat])
    lng_valid = StrUtil::is_valid_float?(p[:lng])

    lat = p[:lat]
    lng = p[:lng]

    if !lat || !lng
      render json: { error: 'Invalid \'lat\' and \'lng\' params. They failed to parse as floating point numbers' }, status: 400 and return
    end

    if lat.to_s.split('.').last.length < 6 || lng.to_s.split('.').last.length < 6
      render json: { error: 'Your latitude and/or longitude coordinates are not precise enough. At least 6 decimal places are required' }, status: 400 and return
    end

    difficulty = p[:difficulty].to_i
    if !difficulty || difficulty < 1 || difficulty > 10
      render json: { error: 'Invalid \'difficulty\' param. It failed to parse as an integer or it was out of range (1 <= x <= 10).' }, status: 400 and return
    end

    return { title: p[:title], description: p[:description], duration: duration, lat: lat.to_s, lng: lng.to_s, difficulty: difficulty }
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

  def update_params
    params.require(:hike_event).permit(:title, :description, :duration, :lat, :lng, :difficulty)
  end

  def fix_params (p)
    fixed = {}
    if p["title"]
      fixed[:title] = p["title"]
    end
    if p["description"]
      fixed[:description] = p["description"]
    end
    if p["duration"]
      fixed[:duration] = p["duration"]
    end
    if p["lat"]
      fixed[:lat] = p["lat"]
    end
    if p["lng"]
      fixed[:lng] = p["lng"]
    end
    if p["difficulty"]
      fixed[:difficulty] = p["difficulty"]
    end
    return fixed
  end

  def parse_duration(p)
    if p[:duration].is_a?(Range)
      return p[:duration]
    end

    duration = p[:duration].split('...')
    unless duration.length != 2
      start = Time.zone.parse(duration[0])
      if !start
        render json: { error: "Invalid start time '#{duration[0]}'" }, status: 400 and return
      end

      finish = Time.zone.parse(duration[1])
      if !finish
        render json: { error: "Invalid finish time '#{duration[1]}'" }, status: 400 and return
      end


      if start >= finish
        render json: { error: "Start time '#{duration[0]}' is after finish time '#{duration[1]}'" }, status: 400 and return
      end

      return (start...finish)
    else
      render json: { error: 'Invalid duration. duration must be in format: \'#<DateTime>...#<DateTime>\'' }, status: 400 and return
    end
  end
end
