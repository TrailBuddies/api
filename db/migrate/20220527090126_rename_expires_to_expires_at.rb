class SetDefaultForExpiresOnTokens < ActiveRecord::Migration[7.0]
  def change
    rename_column :tokens, :expires, :expires_at
  end
end
