class CreateHikes < ActiveRecord::Migration[6.1]
  def change
    create_table :hikes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :trail
      t.timestamp :scheduled_for

      t.timestamps
    end
  end
end
