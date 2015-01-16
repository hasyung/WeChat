class ApplicationController < ActionController::Base

  protect_from_forgery
  after_filter :reset_last_captcha_code!
  before_filter :authenticate_customer!
  
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

  def authenticate_customer!
    if params[:customer_id].blank?
      account = Account.first
      path = Setting.domain + request.env["REQUEST_PATH"]
      if params[:code].blank?
        account.get_oauth_code CGI.escape(path)
      else
        openid = account.get_oauth_openid params[:code]
        member = Member.find_by_open_id openid
        if member.customer.blank?
          redirect_to bound_customers_path(openid: openid, path: path), alert: t('errors.messages.customer.unbound')
        else
          redirect_to path(customer_id: member.customer.id)
        end
      end

    end
  end
end
