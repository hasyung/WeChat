module CarrierWave
  module Media
    include ActionView::Helpers::NumberHelper
    extend ActiveSupport::Concern

    included do

      # @overload info
      # 返回一个FFMPEG::Movie对象
      # 注意：只有在第一次上传时候有值，其他时候为nil
      def info
        @info || nil
      end

      # @overload human_duration
      # 人类可读的时长格式，如00:01:00
      def human_duration
        (Time.mktime(0) + model.send("#{mounted_as.to_s}_duration")).strftime("%H:%M:%S")
      end

      # @overload human_size
      # 人类可读的计算机大小格式，以MB，GB为单位
      def human_size
        number_to_human_size(model.send("#{mounted_as.to_s}_size"))
      end

    end

    def media_info
      cache_stored_file! if !cached?
      @info = ::FFMPEG::Movie.new(current_path)
    end

    module ClassMethods

      def media_info
        process :media_info
      end

    end

  end
end