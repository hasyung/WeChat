# assets register slim template
Rails.application.assets.register_engine('.slim', Slim::Template)

# include helpers for assets 
Rails.application.assets.context_class.class_eval do
  # 注意，此处和Scss的编译有冲突，如果需要编译Scss请注释
  # include Rails.application.routes.url_helpers
  include Rails.application.routes.mounted_helpers
  include ActionView::Helpers
  include SimpleForm::ActionViewExtensions::FormHelper if defined?(SimpleForm)
end