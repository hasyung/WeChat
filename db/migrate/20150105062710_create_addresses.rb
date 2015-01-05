class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references  :customer,    default: 0
      t.string      :name,        null:false
      t.string      :phone,       null:false
      t.string      :address,     null:false
      t.string      :postcode
      t.timestamps
    end

    add_index :addresses, :customer_id
  end
end
