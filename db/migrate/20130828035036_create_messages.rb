class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references  :member,    default: 0
      t.text        :body
      t.integer     :category_cd,   default: 0
      t.timestamps
    end
    add_index :messages, :member_id
  end
end
