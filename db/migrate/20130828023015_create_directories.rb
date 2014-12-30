class CreateDirectories < ActiveRecord::Migration
  def change
    create_table :directories do |t|
      t.references  :account,         null: false
      t.string      :name,            null: false
      t.integer     :audios_count,    default: 0
      t.integer     :articles_count,  default: 0
      t.integer     :albums_count,    default: 0
      t.integer     :kits_count,    default: 0
      t.timestamps
    end
    add_index :directories, :account_id
  end
end
