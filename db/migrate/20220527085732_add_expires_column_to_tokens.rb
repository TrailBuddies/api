class AddExpiresColumnToTokens < ActiveRecord::Migration[7.0]
  def change
    add_column :tokens, :expires, :datetime
  end
end
