class CreateTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :tokens, id: :uuid do |t|
      t.string :token, null: false
      t.bigint :expires_in, null: false, default: 36e+6 # one hour in milliseconds
      t.belongs_to :user, type: :uuid, null: false

      t.timestamps
    end
  end
end
