class KitProfile < ActiveRecord::Base

  include Extension::Uploader

  attr_accessible :file

  audited associated_with: :kit

  # Extension::Uploader
  uploader_media :file, VideoUploader, size: Setting.video_upload_size

  # Relations
  belongs_to :kit, inverse_of: :kit_profile

  # Validates
  validates :file, presence: true
end
