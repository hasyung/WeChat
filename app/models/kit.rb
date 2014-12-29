class Kit < Resource

  attr_accessible :kit_profile_attributes, :cover_cache

  # Relations
  has_one    :kit_profile, inverse_of: :kit
  belongs_to :account,   counter_cache: true
  belongs_to :admin_user

  audited

  accepts_nested_attributes_for :kit_profile

  # Validates
  validates :kit_profile, presence: true, on: :create
end
