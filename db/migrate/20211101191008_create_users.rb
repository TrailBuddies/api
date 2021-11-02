class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    create_table :users, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :username, null: false
      t.string :password, null: false
      t.string :email, null: false
      t.float :location_lat
      t.float :location_lng

      t.timestamps
    end
  end
end
