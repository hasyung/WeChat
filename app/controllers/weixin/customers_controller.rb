class Weixin::CustomersController < Weixin::ApplicationController
  before_filter :authenticate_customer!, except: [:bound]

  def bound
    if request.post?
      customer = nil
      if params[:name] == '新方舟安防' && params[:identity] == '123456'
        current_index = Customer.all.map(&:id).max
        name = '客户' + current_index.to_s
        identity = "#{'0'*(15-current_index.to_s.size)}#{current_index}"
        phone = "#{'0'*(6-current_index.to_s.size)}#{current_index}"
        customer = Customer.create(name: name, identity: identity, phone: phone)
      else
        redirect_to bound_weixin_customers_path, alert: t('errors.messages.customers.uncheck') and return if params[:openid].blank?
        if params[:name].blank? || params[:identity].blank? || params[:phone].blank?
          redirect_to bound_weixin_customers_path(openid: params[:openid], path: params[:path]), alert: t('errors.messages.params_not_null') and return
        end
        customer = Customer.where(name: params[:name], identity: params[:identity], phone: params[:phone]).first
      end

      if customer.present?
        member = Member.find_by_open_id params[:openid]
        customer.member = member
        redirect_to params[:path] + "?customer_id=#{customer.id}", notice: t('successes.messages.customers.bound')
      end
    end
  end

  def address
    @customer = Customer.find params[:customer_id]
    if request.post?
      if @customer.address.blank?
        @address = @customer.build_address params[:customer][:address]
        if @address.save
          redirect_to change_weixin_indents_path(customer_id: @customer, directory_id: params[:directory_id], kit_id: params[:kit_id]), notice: t('successes.messages.customers.address_new')
             else
               render :address
             end
      else
        if @customer.address.update_attributes params[:customer][:address]
          redirect_to change_weixin_indents_path(customer_id: @customer, directory_id: params[:directory_id], kit_id: params[:kit_id]), notice: t('successes.messages.customers.address_update')
             else
               render :address
             end
      end
    end
  end

end