class AddFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :verified, :boolean
    add_column :users, :admin, :boolean
  end
end
