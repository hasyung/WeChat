class CreateAlbumProfiles < ActiveRecord::Migration
  def change
    create_table :album_profiles do |t|
      t.references  :album, default: 0
      t.integer     :type_cd, default: 0
      t.timestamps
    end
  end
end
