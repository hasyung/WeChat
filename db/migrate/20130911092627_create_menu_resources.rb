class CreateMenuResources < ActiveRecord::Migration
  def change
    create_table :menu_resources do |t|
      t.references  :menu,      default: 0
      t.references  :resource,  default: 0
      t.integer     :order,     default: 0
      t.timestamps
    end
    add_index :menu_resources, [:menu_id, :resource_id]
  end
end
