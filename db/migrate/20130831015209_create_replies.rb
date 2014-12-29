class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.references  :account,               default: 0
      t.references  :parent,                default: 0
      t.string      :number
      t.string      :name
      t.text        :body
      t.string      :tags
      t.integer     :category_cd,           default: 0
      t.boolean     :is_system,             default: false
      t.integer     :reply_resources_count, default: 0
      t.timestamps
    end
    add_index :replies, :account_id
    add_index :replies, :parent_id
    add_index :replies, :number
    add_index :replies, :name
  end
end
