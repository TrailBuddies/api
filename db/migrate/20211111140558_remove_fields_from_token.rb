class RemoveFieldsFromToken < ActiveRecord::Migration[6.1]
  def change
    remove_column :tokens, :admin
    remove_column :tokens, :verified
  end
end
