require File.expand_path('../boot', __FILE__)
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "sprockets/railtie"
require "rails/all"

if defined?(Bundler)
  Bundler.require(*Rails.groups(:assets => %w(development test)))
end

module OneTripWeChat
  class Application < Rails::Application
    config.cache_store = :redis_store

    config.paths.add "app/api", :glob => "**/*.rb"

    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += %W(#{config.root}/app/api)

    config.time_zone = 'Beijing'

    config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]

    config.i18n.default_locale = 'zh-CN'

    config.encoding = "utf-8"

    config.filter_parameters += [:password, :password_confirmation]

    config.active_support.escape_html_entities_in_json = true

    config.assets.enabled = true

    config.assets.version = '1.0'

    config.middleware.use Rack::ContentLength
  end
end
