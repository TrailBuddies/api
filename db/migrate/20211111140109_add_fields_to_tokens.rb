class AddFieldsToTokens < ActiveRecord::Migration[6.1]
  def change
    add_column :tokens, :admin, :boolean, null: false, default: false
    add_column :tokens, :verified, :boolean, null: false, default: false
  end
end
