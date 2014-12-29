class Article < Resource

  attr_accessible :article_profile_attributes, :cover_cache

  # Relations
  has_one    :article_profile, inverse_of: :article
  belongs_to :directory, counter_cache: true
  belongs_to :account,   counter_cache: true
  belongs_to :admin_user

  audited

  accepts_nested_attributes_for :article_profile

  validates :article_profile, presence: true, on: :create
end
