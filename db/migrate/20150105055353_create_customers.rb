class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string      :name,       null: false
      t.string      :identity,   null: false
      t.string      :phone,      null: false
      t.string      :department  
      t.timestamps
    end

    add_index  :customers, :name
  end
end
