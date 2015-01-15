class AddItemsCountToDirectoryKits < ActiveRecord::Migration
  def change
  	add_column :directory_kits, :items_count, :integer, default: 0
  end
end
