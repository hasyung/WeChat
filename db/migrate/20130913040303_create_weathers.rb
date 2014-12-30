class CreateWeathers < ActiveRecord::Migration
  def change
    create_table :weathers do |t|
      t.references  :account, null: false
      t.string      :name,    null: false, limit: 50
      t.text        :body,    limit: 3000
      t.datetime    :weather_at
      t.timestamps
    end

    add_index :weathers, :name
  end
end
