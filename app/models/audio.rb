class Audio < Resource

  attr_accessible :audio_profile_attributes, :cover_cache
  
  # Relations
  has_one     :audio_profile, inverse_of: :audio
  belongs_to  :directory, counter_cache: true
  belongs_to  :account,   counter_cache: true
  belongs_to  :admin_user

  audited

  accepts_nested_attributes_for :audio_profile
  
  # Validates
  validates :audio_profile, presence: true, on: :create
end
