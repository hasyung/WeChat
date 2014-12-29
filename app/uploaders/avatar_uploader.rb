# encoding: utf-8

class AvatarUploader < ImageUploader

  def default_url
    'avatars/avatar.png'
  end

  process :resize_to_fit => [160, 160]

  version :small do
    process :resize_to_fill => [80, 80]
  end

end