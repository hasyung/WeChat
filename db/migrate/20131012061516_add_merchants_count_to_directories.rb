class AddMerchantsCountToDirectories < ActiveRecord::Migration
  def up
    add_column :directories, :merchants_count, :integer
  end

  def down
    remove_column :directories, :merchants_count
  end
end
