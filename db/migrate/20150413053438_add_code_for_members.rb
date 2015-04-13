class AddCodeForMembers < ActiveRecord::Migration
  def change
    add_column :members, :code, :string
    add_index :members, :code
  end
end
