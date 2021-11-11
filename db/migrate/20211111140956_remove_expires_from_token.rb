class RemoveExpiresFromToken < ActiveRecord::Migration[6.1]
  def change
    remove_column :tokens, :expires_in
  end
end
