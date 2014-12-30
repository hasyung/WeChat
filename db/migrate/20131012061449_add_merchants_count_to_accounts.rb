class AddMerchantsCountToAccounts < ActiveRecord::Migration
  def up
    add_column :accounts, :merchants_count, :integer
  end

  def down
    remove_column :accounts, :merchants_count
  end
end
