class CreateIndents < ActiveRecord::Migration
  def change
    create_table :indents do |t|
      t.references  :customer,    null: false
      t.references  :kit,         null: false
      t.string      :code,        null: false
      t.integer     :item_count,  default: 1
      t.string      :logistics
      t.string      :logistics_code
      t.float       :freight,     default: 0
      t.float       :price_count, default: 0
      t.integer     :type_cd,     null: false
      t.timestamps
    end

    add_index  :indents, :code, unique: true
  end
end
