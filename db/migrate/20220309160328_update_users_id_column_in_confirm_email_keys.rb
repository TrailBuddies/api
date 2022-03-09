class UpdateUsersIdColumnInConfirmEmailKeys < ActiveRecord::Migration[7.0]
  def change
    rename_column :confirm_email_keys, :users_id, :user_id
  end
end
