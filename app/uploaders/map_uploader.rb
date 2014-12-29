# encoding: utf-8

class MapUploader < BaseUploader

  def extension_white_list
    Setting.upload_image_extension
  end

  def store_dir
    "#{Setting.upload_dir}/maps/#{model.class.to_s.pluralize.underscore}/#{mounted_as.to_s.pluralize.underscore}"
  end

  version :default do
    process resize_to_limit: [960, nil]
  end

  version :big do
    process resize_to_fill: [640, 320]
  end

end
