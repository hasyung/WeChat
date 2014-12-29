class ChangeLngAndLatToRplies < ActiveRecord::Migration
  def up
    change_column :replies, :lng, :float, default: nil
    change_column :replies, :lat, :float, default: nil
    add_index :replies, :lng
    add_index :replies, :lat
  end

  def down
    change_column :replies, :lng, :float, default: ''
    change_column :replies, :lat, :float, default: ''
    remove_index :replies, :lng
    remove_index :replies, :lat
  end
end
