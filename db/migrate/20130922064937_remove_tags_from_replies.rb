class RemoveTagsFromReplies < ActiveRecord::Migration
  def up
    remove_column :replies, :tags
  end

  def down
    add_column :replies, :tags, :string
  end
end
