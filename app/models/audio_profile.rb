class AudioProfile < ActiveRecord::Base
  
  include Extension::Uploader
  
  attr_accessible :file
  
  # Extension::Uploader
  uploader_media :file, AudioUploader, size: Setting.audio_upload_size
  
  # Relations
  belongs_to :audio, inverse_of: :audio_profile

  audited associated_with: :audio

  # Validates
  validates :file, presence: true
  
end
