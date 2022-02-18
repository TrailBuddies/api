class RemoveColumnFromHikeevents < ActiveRecord::Migration[7.0]
  def change
    remove_column :hike_events, :image_url
  end
end
