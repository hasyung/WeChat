class CreateKitProfiles < ActiveRecord::Migration
  def change
    create_table :kit_profiles do |t|
      t.references  :kit, default: 0
      t.string      :file
      t.string      :file_type
      t.integer     :file_size,     default: 0
      t.integer     :file_duration, default: 0
      t.timestamps
    end
    add_index :kit_profiles, :kit_id
  end
end
