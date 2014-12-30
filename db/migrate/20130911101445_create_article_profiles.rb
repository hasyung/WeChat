class CreateArticleProfiles < ActiveRecord::Migration
  def change
    create_table :article_profiles do |t|
      t.references  :article, default: 0
      t.text        :body
      t.timestamps
    end
  end
end
