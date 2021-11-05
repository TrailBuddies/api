class UpdateUsersTable < ActiveRecord::Migration[6.1]
  def change
    change_table :users do |t|
      t.change :email, :string, null: false
      t.change :password, :string, null: false
      t.change :username, :string, null: false
    end
  end
end
