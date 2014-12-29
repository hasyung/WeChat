# encoding: utf-8

class ImageUploader < BaseUploader

  def extension_white_list
    Setting.upload_image_extension
  end

  def store_dir
    "#{Setting.upload_dir}/images/#{model.class.to_s.pluralize.underscore}/#{mounted_as.to_s.pluralize.underscore}/#{model.id}"
  end

  def default_url
    asset_path("defaults/images/#{model.class.to_s.pluralize.underscore}/#{mounted_as.to_s.pluralize.underscore}/" +
      [version_name, "default.png"].compact.join('_'))
  end

end
