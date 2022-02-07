class UpdateHikeEventModel < ActiveRecord::Migration[7.0]
  def change
    change_column_null :hike_events, :title, false
    change_column_null :hike_events, :description, false
    change_column_null :hike_events, :duration, false
    change_column_null :hike_events, :lat, false
    change_column_null :hike_events, :lng, false
    change_column_null :hike_events, :difficulty, false
  end
end
