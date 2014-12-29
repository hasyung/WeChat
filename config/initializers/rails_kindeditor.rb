RailsKindeditor.setup do |config|

  # Specify the subfolders in public directory.
  # You can customize it , eg: config.upload_dir = 'this/is/my/folder'
  config.upload_dir = Setting.upload_dir

  # Allowed file types for upload.
  config.upload_image_ext = Setting.upload_image_extension
  config.upload_flash_ext = Setting.upload_flash_extension
  config.upload_media_ext = Setting.upload_media_extension
  config.upload_file_ext = Setting.upload_file_extension
  
  # Porcess upload image size
  # eg: 1600x1600 => 800x800
  #     1600x800  => 800x400
  #     400x400   => 400x400  # No Change
  # config.image_resize_to_limit = [800, 800]

end
