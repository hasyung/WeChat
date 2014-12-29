class AddLocationToReplies < ActiveRecord::Migration
  def change
    add_column :replies, :lat, :string, default: ''
    add_column :replies, :lng, :string, default: ''
  end
end
