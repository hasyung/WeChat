class CreateGuides < ActiveRecord::Migration
  def change
    create_table :guides do |t|
      t.references  :account, null: false
      t.string :name, null:false, limit: 200
      t.string :qualificationscardno, limit:200
      t.text        :body,    limit: 3000
      t.timestamps
    end

    add_index :guides, :name
    add_index :guides, :qualificationscardno, unique: true
  end
end
