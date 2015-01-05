class KitProfile < ActiveRecord::Base

  include Extension::Uploader

  attr_accessible :file, :category_cd

  audited associated_with: :kit
  
  as_enum :category, Setting.enums.kit_category.dup.symbolize_keys, prefix: true

  # Extension::Uploader
  uploader_media :file, VideoUploader, size: Setting.video_upload_size

  # Relations
  belongs_to :kit, inverse_of: :kit_profile

  # Validates
  validates :file, :category_cd, presence: true
end
