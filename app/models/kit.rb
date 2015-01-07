class Kit < Resource

  attr_accessible :images_attributes, :kit_profile_attributes

  # Relations
  has_one    :kit_profile, inverse_of: :kit
  belongs_to :account,   counter_cache: true
  belongs_to :admin_user
  has_many   :directory_kits
  has_many   :directories, through: :directory_kits
  has_many   :images,    dependent: :destroy
  has_many   :indents

  audited

  accepts_nested_attributes_for :kit_profile
  accepts_nested_attributes_for :images

  # Validates
  validates :kit_profile, presence: true, on: :create

end
