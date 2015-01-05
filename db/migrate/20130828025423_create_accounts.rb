class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string      :name,                      null: false
      t.string      :alias,                     null: false
      t.string      :token,                     null: false
      t.string      :app_id
      t.string      :app_secret
      t.string      :access_token
      t.string      :identifier
      t.text        :description
      t.datetime    :updated_access_token_at
      t.integer     :expires_in,                default: 0
      t.integer     :members_count,             default: 0
      t.integer     :kits_count,                default: 0
      t.integer     :directories_count,         default: 0
      t.integer     :menus_count,               default: 0
      t.integer     :replies_count,             default: 0
      t.timestamps
    end
    add_index :accounts, :alias
  end
end
