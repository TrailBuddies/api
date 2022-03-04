class RequireUsersColumnOnHikeEvents < ActiveRecord::Migration[7.0]
  def change
    change_column :hike_events, :users, :uuid, null: false, array: true, default: []
  end
end
