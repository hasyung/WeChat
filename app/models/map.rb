class Map < Resource

  attr_accessible :map_profile_attributes, :cover_cache
  
  # Relations
  has_one     :map_profile, inverse_of: :map
  belongs_to  :directory, counter_cache: true
  belongs_to  :account,   counter_cache: true
  belongs_to  :admin_user

  audited

  accepts_nested_attributes_for :map_profile
  
  # Validates
  validates :map_profile, presence: true, on: :create
end
