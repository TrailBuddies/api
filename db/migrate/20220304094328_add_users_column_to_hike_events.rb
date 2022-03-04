class AddUsersColumnToHikeEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :hike_events, :users, :uuid, array: true, default: []
  end
end
