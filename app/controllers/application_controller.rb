class ApplicationController < ActionController::Base

  protect_from_forgery
  after_filter :reset_last_captcha_code!
  
  def after_sign_in_path_for(resource)
    case resource.class.name.underscore.to_sym
    when :admin_user
      admin_root_path
    when :user
      root_path
    end
  end
  
  def after_sign_out_path_for(resource)
    case resource
    when :admin_user
      admin_root_path
    when :user
      root_path
    end
  end
end
