class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.references  :album,     default: 0
      t.string      :title
      t.string      :file
      t.string      :file_type
      t.integer     :file_size, default: 0
      t.integer     :order,     default: 0
      t.timestamps
    end
    add_index :images, :album_id
    add_index :images, :title
  end
end
