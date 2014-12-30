class CreateAudioProfiles < ActiveRecord::Migration
  def change
    create_table :audio_profiles do |t|
      t.references  :audio, default: 0
      t.string      :file
      t.string      :file_type
      t.integer     :file_size,     default: 0
      t.integer     :file_duration, default: 0
      t.timestamps
    end
    add_index :audio_profiles, :audio_id
  end
end
