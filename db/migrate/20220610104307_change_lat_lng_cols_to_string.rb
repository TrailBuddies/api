class ChangeLatLngColsToString < ActiveRecord::Migration[7.0]
  def change
    change_column :hike_events, :lat, :string
    change_column :hike_events, :lng, :string
  end
end
