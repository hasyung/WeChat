class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.references  :account,       default: 0
      t.string      :type
      t.string      :title
      t.text        :description
      t.string      :cover
      t.string      :cover_type
      t.integer     :cover_size
      t.timestamps
    end
    add_index :resources, :account_id
    add_index :resources, :type
  end
end
