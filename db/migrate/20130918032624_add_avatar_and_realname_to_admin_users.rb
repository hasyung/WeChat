class AddAvatarAndRealnameToAdminUsers < ActiveRecord::Migration
  def up
    add_column :admin_users, :avatar, :string
    add_column :admin_users, :realname, :string, limit: 60
  end

  def down
    remove_column :admin_users, :avatar
    remove_column :admin_users, :realname
  end
end
