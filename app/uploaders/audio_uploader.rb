# encoding: utf-8

require 'carrierwave/media'

class AudioUploader < BaseUploader
  include CarrierWave::Media

  process :media_info

  def move_to_store
    true
  end

  def extension_white_list
    Setting.upload_audio_extension
  end

  def store_dir
    "#{Setting.upload_dir}/audios/#{model.class.to_s.pluralize.underscore}/#{mounted_as.to_s.pluralize.underscore}"
  end

end
