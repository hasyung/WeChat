class AddIndexForGuidesAndWeathers < ActiveRecord::Migration
  def change
    add_index :weathers, :account_id
    add_index :guides, :account_id
  end
end
