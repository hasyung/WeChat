class Directory < ActiveRecord::Base
  include Extension::DataTable

  attr_accessible :name, :account_id

  # Relations
  has_many    :resources
  has_many    :audios
  has_many    :articles
  has_many    :videos
  has_many    :albums
  has_many    :merchants
  has_many    :maps
  belongs_to  :account, counter_cache: true

  audited

  # Validates
  validates :name, :account_id, presence: true
  with_options presence: true do |directory|
    directory.validates :name, length: { maximum: 100 }
    directory.validates :name, uniqueness: { scope: :account_id }
  end

end
