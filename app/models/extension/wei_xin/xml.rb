module Extension
  module WeiXin
    module XML

      extend ActiveSupport::Concern
      include Rails.application.routes.url_helpers
      include ActionDispatch::Routing::PolymorphicRoutes

      included do

        # @overload to_wx_member(member)
        #   转换一个对象为微信使用的XML
        #   目前转换数据格式为文字和图文两种
        #   @param [member] 指定用户（一个member对象的open id）
        #
        # @example A custom builder
        #   class Person
        #     include Extension::WeiXin::XML
        #
        #     @object = Object.first
        #     @member = Member.first
        #     @object.to_wx_member @member.open_id
        #   end
        #
        def to_weixin_xml(member)
          builder = Nokogiri::XML::Builder.new encoding: 'UTF-8' do |xml|
            xml.xml {
              xml.ToUserName { xml.text member }
              xml.FromUserName { xml.text self.account.identifier }
              xml.CreateTime { xml.text DateTime.now.to_i }
              xml.MsgType do
                case self.category
                when :text then xml.text self.category.to_s
                when :resource then xml.text 'news'
                end
              end
              case self.category
              when :text
                xml.Content { xml.text self.body.gsub("{{list}}", member) }
              when :resource
                build_resource xml
              end
            }
          end
        end

        private

        def build_resource xml
          xml.ArticleCount { xml.text self.resources.size }
          xml.Articles {
            self.resources.each_with_index do |resource, index|
              xml.item {
                xml.Title { xml.text resource.title }
                xml.Description { xml.text resource.description }
                xml.PicUrl { xml.text index.zero? ? resource.cover.big.url : resource.cover.small.url }
                xml.Url do
                  if resource.respond_to?(:url) and resource.send(:url).present?
                    xml.text resource.url
                  elsif resource.type == 'Article' and resource.article_profile.url.present?
                    xml.text resource.article_profile.url
                  elsif resource.type == 'Merchant' and resource.merchant_profile.url.present?
                    xml.text resource.merchant_profile.url
                  else
                    xml.text "#{Setting.we_chat.oauth2_get_code_url}?appid=#{account.app_id}&redirect_uri=#{CGI.escape(polymorphic_url([resource, Kit]))}&response_type=code&scope=snsapi_base&state=200#wechat_redirect"
                  end
                end
              }
            end
          }
        end

      end
    end
  end
end
