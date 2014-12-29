module Weixin
  class Router

    # 支持以下形式
    # WeixinRouter.new(type: "text")
    # WeixinRouter.new(type: "text", content: "Hello2BusUser")
    # WeixinRouter.new(type: "text", content: /^@/)
    # WeixinRouter.new { |xml| xml[:MsgType] == 'image' }
    # WeixinRouter.new(type: "text") { |xml| xml[:Content].starts_with? "@" }
    def initialize(type, options = {}, &block)
      @type = type.to_sym
      @content = options[:content] if options[:content]
      @constraint = block if block_given?
    end

    def matches?(request)
      xml = request.params[:xml]
      result = true
      result = result && (xml[:MsgType].to_sym == @type) if @type
      result = result && (xml[:Content] =~ @content) if @content.is_a? Regexp
      result = result && (xml[:Content] == @content) if @content.is_a? String
      result = result && @constraint.call(xml) if @constraint
      return result
    end
  end

  module ActionController
    # 辅助方法，用于简化操作，weixin_request.content 比用hash舒服多了，对不？
    def weixin_request
      @weixin_request ||= WeixinRequest.new(params)
      return @weixin_request
    end

    class WeixinRequest
      attr_accessor :signature, :timestamp, :nonce, :echostr, :alias, :msg_id, :body, :type, :from_user, :to_user
      def initialize(hash)
        @signature = hash[:signature]
        @timestamp = hash[:timestamp]
        @nonce = hash[:nonce]
        @echostr = hash[:echostr]
        @alias = hash[:alias]
        if hash[:xml].present?
          @type = hash[:xml][:MsgType]
          @from_user = hash[:xml][:FromUserName]
          @to_user = hash[:xml][:ToUserName]
          @msg_id = hash[:xml][:MsgId]
          @body = {}
          build_text(hash) if @type == "text"
          build_image(hash) if @type == "image"
          build_video(hash) if @type == "video"
          build_location(hash) if @type == "location"
          build_voice(hash) if @type == "voice"
          build_link(hash) if @type == "link"
          build_event(hash) if @type == "event"
        end
      end

      def build_text hash
        @body[:text] = hash[:xml][:Content]
      end

      def build_image hash
        @body[:pic_url] = hash[:xml][:PicUrl]
        @body[:media_id] = hash[:xml][:MediaId]
      end

      def build_video hash
        @body[:media_id] = hash[:xml][:MediaId]
        @body[:thumb_media_id] = hash[:xml][:ThumbMediaId]
      end

      def build_location hash
        @body[:x] = hash[:xml][:Location_X]
        @body[:y] = hash[:xml][:Location_Y]
        @body[:scale] = hash[:xml][:Scale]
        @body[:label] = hash[:xml][:Label]
      end

      def build_voice hash
        @body[:meida_id] = hash[:xml][:MediaId]
        @body[:format] = hash[:xml][:Format]
        @body[:recognition] = hash[:xml][:Recognition]
        @body[:text] = hash[:xml][:Recognition]
      end

      def build_link hash
        @body[:title] = hash[:xml][:Title]
        @body[:description] = hash[:xml][:Description]
        @body[:url] = hash[:xml][:Url]
      end

      def build_event hash
        @body[:event] = hash[:xml][:Event].downcase
        @body[:event_key] = hash[:xml][:EventKey]
        @body[:ticket] = hash[:xml][:ticket] if hash[:xml][:ticket].present?
      end
    end
  end
end

ActionController::Base.class_eval do
  include ::Weixin::ActionController
end

ActionView::Base.class_eval do
  include ::Weixin::ActionController
end