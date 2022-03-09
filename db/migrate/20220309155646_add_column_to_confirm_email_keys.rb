class AddColumnToConfirmEmailKeys < ActiveRecord::Migration[7.0]
  def change
    add_column :confirm_email_keys, :expires_in_s, :int, null: false
    change_column :confirm_email_keys, :key, :string, null: false
    change_column :confirm_email_keys, :users_id, :uuid, null: false
  end
end
