class AddAdminUserIdToReplies < ActiveRecord::Migration
  def change
    add_column :replies, :admin_user_id, :integer, default: 0
    add_index :replies, :admin_user_id
  end
end
