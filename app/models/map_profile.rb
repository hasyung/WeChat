class MapProfile < ActiveRecord::Base

  include Extension::Uploader

  attr_accessible :file

  # Extension::Uploader
  uploader_media :file, MapUploader, size: Setting.image_upload_size

  # Relations
  belongs_to :map, inverse_of: :map_profile

  audited associated_with: :map

  # Validates
  validates :file, presence: true

end
