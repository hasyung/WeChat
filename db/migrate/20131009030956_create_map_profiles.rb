class CreateMapProfiles < ActiveRecord::Migration
  def change
    create_table :map_profiles do |t|
      t.references  :map, default: 0
      t.string      :file
      t.string      :file_type
      t.integer     :file_size,     default: 0
      t.timestamps
    end
    add_index :map_profiles, :map_id

    add_column :accounts,    :maps_count, :integer, default: 0
    add_column :directories, :maps_count, :integer, default: 0
  end
end
