class Album < Resource
  attr_accessible :images_attributes, :album_profile_attributes, :cover_cache

  # Relations
  has_many    :images,    dependent: :destroy
  has_one     :album_profile, autosave: true
  belongs_to  :account,   counter_cache: true
  belongs_to  :admin_user

  audited

  accepts_nested_attributes_for :images
  accepts_nested_attributes_for :album_profile, update_only: true

end
