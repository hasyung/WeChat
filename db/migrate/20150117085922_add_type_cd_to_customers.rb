class AddTypeCdToCustomers < ActiveRecord::Migration
  def change
  	add_column :customers, :type_cd, :integer, default: 0
  end
end
