class DropHikejoinrequest < ActiveRecord::Migration[7.0]
  def change
    drop_table :event_join_requests
  end
end
