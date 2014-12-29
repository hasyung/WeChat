class AddQrCodeToReplies < ActiveRecord::Migration
  def change
    add_column :replies, :scene_id, :integer, default: 0
    add_column :replies, :ticket, :string
    add_column :replies, :scene_delete, :boolean, default: false
    
    add_index :replies, :scene_id
  end
end
