class Weixin::ApplicationController < ActionController::Base

  before_filter :authenticate_customer!

  def authenticate_customer!
    # params[:customer_id] = Customer.first.id
    if params[:customer_id].blank?
      account = Account.first
      if params[:code].present?
        openid = account.get_oauth_openid params[:code]
        if openid
          member = Member.find_by_open_id(openid)
          member.update(code: params[:code])
        else
          member = Member.find_by_code(params[:code])
        end
        member = Member.create(account_id: account, open_id: openid, code: params[:code]) if member.blank?
        if member.customer.blank?
          redirect_to bound_weixin_customers_path(openid: openid, path: request.path), alert: t('errors.messages.customers.unbound')
        else
          params[:customer_id] = member.customer.id
        end
      else
        redirect_to bound_weixin_customers_path, alert: t('errors.messages.customers.uncheck')
      end
    end
  end

end
