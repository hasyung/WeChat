class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :account,    null: false
      t.string :open_id,        null: false
      t.string :booth,          null: false
      t.string :phone,          null: false
      t.integer :order,         default: 0

      t.timestamps
    end
    add_index :votes, :open_id
    add_index(:votes, [:account_id, :order], unique: true)
  end
end
