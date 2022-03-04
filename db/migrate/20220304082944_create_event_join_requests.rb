class CreateEventJoinRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :event_join_requests, id: :uuid do |t|
      t.boolean :confirmed, null: false, default: false

      t.timestamps
    end


    add_reference :event_join_requests, :hike_events, null: false, foreign_key: true, type: :uuid
    add_reference :event_join_requests, :users, null: false, foreign_key: true, type: :uuid
  end
end
