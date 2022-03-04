class AddUnconfirmedColumnToHikeEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :hike_events, :users_unconfirmed, :uuid, array: true, default: [], null: false
  end
end
