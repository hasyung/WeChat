class AddVotesCountToAccounts < ActiveRecord::Migration
  def up
    add_column :accounts, :votes_count, :integer, default: 0
  end

  def down
    remove_column :accounts, :votes_count
  end
end
