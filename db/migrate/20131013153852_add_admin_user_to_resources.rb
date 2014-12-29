class AddAdminUserToResources < ActiveRecord::Migration
  def change
    add_column :resources, :admin_user_id, :integer, default: 0
    add_index :resources, :admin_user_id
  end
end
