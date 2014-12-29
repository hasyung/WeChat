require 'carrierwave/media'
# encoding: utf-8

class VideoUploader < BaseUploader
  include CarrierWave::Media
  
  process :media_info
  
  def move_to_store
    true
  end

  def extension_white_list
    Setting.upload_video_extension
  end
  
  def store_dir
    "#{Setting.upload_dir}/videos/#{model.class.to_s.pluralize.underscore}/#{mounted_as.to_s.pluralize.underscore}"
  end

end
