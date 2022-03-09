class CreateConfirmEmailKeys < ActiveRecord::Migration[7.0]
  def change
    create_table :confirm_email_keys, id: :uuid do |t|
      t.string :key

      t.timestamps
    end

    add_reference :confirm_email_keys, :users, foreign_key: true, type: :uuid
  end
end
