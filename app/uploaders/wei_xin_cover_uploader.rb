# encoding: utf-8

class WeiXinCoverUploader < ImageUploader

  version :big do
    process resize_to_fill: [640, 320]
    # process watermark: Setting.watermark.video_big, if: :is_video?
    # process watermark: Setting.watermark.audio_big, if: :is_audio?
    # process watermark: Setting.watermark.album_big, if: :is_album?
    # process watermark: Setting.watermark.map_big, if: :is_map?
  end

  version :middle1x do
    process resize_to_fit: [375, 400]
  end

  version :middle do
    process resize_to_fill: [200, 120]
  end

  version :small do
    process resize_to_fill: [80, 80]
    # process watermark: Setting.watermark.video_small, if: :is_video?
    # process watermark: Setting.watermark.audio_small, if: :is_audio?
    # process watermark: Setting.watermark.album_small, if: :is_album?
    # process watermark: Setting.watermark.map_small, if: :is_map?
  end

  protected
  def watermark file_name
    manipulate! do |img|
      logo = MiniMagick::Image.open("#{Rails.root}/#{file_name}")
      img = img.composite(logo, "jpg") do |c|
        c.gravity "Center"
      end
    end
  end

  # def is_audio?(file)
  #   model.is_a?(Audio)
  # end

  def is_video?(file)
    model.is_a?(Kit)
  end

  # def is_album?(file)
  #   model.is_a?(Album)
  # end

  # def is_map?(file)
  #   model.is_a?(Map)
  # end

end
