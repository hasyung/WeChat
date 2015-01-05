class CreateDirectoryKits < ActiveRecord::Migration
  def change
    create_table :directory_kits do |t|
	  t.belongs_to :directory,         null: false, index: true
	  t.belongs_to :kit,               null: false, index: true
      t.timestamps
    end
  end
end
