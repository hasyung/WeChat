class CreateMerchantProfiles < ActiveRecord::Migration
  def change
    create_table :merchant_profiles do |t|
      t.references  :merchant, default: 0
      t.integer     :type_cd,  default: 0
      t.string      :url
      t.text        :body
      t.timestamps
    end
  end
end
