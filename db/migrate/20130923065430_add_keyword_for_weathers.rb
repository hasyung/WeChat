class AddKeywordForWeathers < ActiveRecord::Migration
  def change
    add_column :weathers, :keyword, :string, null: false
  end
end
