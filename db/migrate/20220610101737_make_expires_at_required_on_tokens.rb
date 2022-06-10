class MakeExpiresAtRequiredOnTokens < ActiveRecord::Migration[7.0]
  def change
    change_column :tokens, :expires_at, :datetime, null: false
  end
end
