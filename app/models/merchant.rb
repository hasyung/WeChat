class Merchant < Resource
  attr_accessible :merchant_images_attributes, :merchant_profile_attributes, :cover_cache

  # Relations
  has_many    :merchant_images,    dependent: :destroy
  has_one     :merchant_profile,   autosave: true
  belongs_to  :directory,          counter_cache: true
  belongs_to  :account,            counter_cache: true
  belongs_to  :admin_user

  audited

  accepts_nested_attributes_for :merchant_images
  accepts_nested_attributes_for :merchant_profile, update_only: true

end
