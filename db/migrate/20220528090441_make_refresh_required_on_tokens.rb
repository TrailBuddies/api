class MakeRefreshRequiredOnTokens < ActiveRecord::Migration[7.0]
  def change
    change_column :tokens, :refresh, :string, null: false
  end
end
