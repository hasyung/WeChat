class AddRoleMaskToAdminUsers < ActiveRecord::Migration
  def change
    add_column :admin_users, :roles_mask, :integer, default: 0
  end
end
