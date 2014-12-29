class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.references  :account,         default: 0
      t.string      :open_id
      t.string      :nickname
      t.integer     :sex_cd,          default: 0
      t.string      :city
      t.string      :language
      t.boolean     :subscribe,       default: false
      t.datetime    :last_reply_at
      t.integer     :messages_count,  default: 0
      t.integer     :action_cd,       default: 0
      t.timestamps
    end
    add_index :members, :account_id
    add_index :members, :open_id
  end
end
