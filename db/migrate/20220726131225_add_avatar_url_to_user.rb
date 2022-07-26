class AddAvatarUrlToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :avatar_url, :string, null: false, default: 'default-avatar'
  end
end
