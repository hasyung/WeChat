# encoding: utf-8

class PictureUploader < ImageUploader

  version :big do
    process :resize_to_fill => [350, 450]
  end

  version :small do
    process :resize_to_fill => [80, 80]
  end

end
