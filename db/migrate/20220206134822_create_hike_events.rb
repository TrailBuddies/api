class CreateHikeEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :hike_events, id: :uuid do |t|
      t.string :title
      t.string :description
      t.daterange :duration
      t.decimal :lat, precision: 10, scale: 6
      t.decimal :lng, precision: 10, scale: 6
      t.integer :difficulty
      t.string :image_url

      t.timestamps
    end
  end
end
