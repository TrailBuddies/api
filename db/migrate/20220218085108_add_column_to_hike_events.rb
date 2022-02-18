class AddColumnToHikeEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :hike_events, :image_url, :string
  end
end
