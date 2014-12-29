class CreateReplyResources < ActiveRecord::Migration
  def change
    create_table :reply_resources do |t|
      t.references  :reply,     default: 0
      t.references  :resource,  default: 0
      t.integer     :order,     default: 0
      t.timestamps
    end
    add_index :reply_resources, [:reply_id, :resource_id]
  end
end
