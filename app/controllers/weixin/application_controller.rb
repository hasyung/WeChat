class Weixin::ApplicationController < ActionController::Base

  before_filter :authenticate_customer!

  def authenticate_customer!
    params[:customer_id] = Customer.first.id
    if params[:customer_id].blank?
      account = Account.first
      if params[:code].present?
        openid = account.get_oauth_openid params[:code]
        member = Member.find_by_open_id openid
        if member.customer.blank?
          redirect_to bound_weixin_customers_path(openid: openid), alert: t('errors.messages.customers.unbound')
        else
          params[:customer_id] = member.customer.id
        end
      else
        redirect_to bound_weixin_customers_path, alert: t('errors.messages.customers.uncheck')
      end
    end
  end

end
