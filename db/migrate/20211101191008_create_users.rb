class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_hash
      t.string :email
      t.float :location_lat
      t.float :location_lng

      t.timestamps
    end
  end
end
