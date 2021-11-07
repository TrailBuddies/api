class UpdateUserFields < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :verified, :string, null: false, default: 'pending'
    change_column :users, :admin, :boolean, null: false, default: false
  end
end
