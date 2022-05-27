class RenameTokenInTokens < ActiveRecord::Migration[7.0]
  def change
    rename_column :tokens, :token, :access
  end
end
