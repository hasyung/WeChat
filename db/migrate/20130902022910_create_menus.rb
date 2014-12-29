class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.references  :account,               default: 0
      t.references  :parent,                default: 0
      t.integer     :category_cd,           default: 0
      t.string      :name
      t.text        :body
      t.string      :url
      t.integer     :action_cd,             default: 0
      t.integer     :order,                 default: 0
      t.boolean     :soft_delete,           default: false
      t.boolean     :is_complete,           default: false
      t.integer     :menu_resources_count,  default: 0
      t.timestamps
    end
    add_index :menus, :account_id
    add_index :menus, :parent_id
  end
end
