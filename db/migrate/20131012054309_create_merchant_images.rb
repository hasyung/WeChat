class CreateMerchantImages < ActiveRecord::Migration
  def change
    create_table :merchant_images do |t|
      t.references  :merchant,  default: 0
      t.string      :title
      t.string      :file
      t.string      :file_type
      t.integer     :file_size, default: 0
      t.integer     :order,     default: 0
      t.timestamps
    end
    add_index :merchant_images, :merchant_id
    add_index :merchant_images, :title
  end
end
