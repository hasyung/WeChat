class ArticleProfile < ActiveRecord::Base

  attr_accessible :body, :url

  # Relations
  belongs_to :article, inverse_of: :article_profile

  audited associated_with: :article

  validates :body, presence: true, if: ->(m) { m.url.blank? }
  validates :url, format: /http:\/\/([\w-]+\.)+[\w-]+(.*)?/, if: ->(m) { m.url.present? }
end
