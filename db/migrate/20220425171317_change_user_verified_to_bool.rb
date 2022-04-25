class ChangeUserVerifiedToBool < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :verified
    add_column :users, :verified, :boolean, default: false, null: false
  end
end
