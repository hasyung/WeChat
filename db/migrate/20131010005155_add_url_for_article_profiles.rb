class AddUrlForArticleProfiles < ActiveRecord::Migration
  def change
    add_column :article_profiles, :url, :string, after: :body
  end
end
