class CustomersController < ApplicationController
	before_filter :authenticate_customer!, except: [:bound]

	def bound
		if request.post?
			redirect_to bound_customers_path(path: params[:path]), alert: t('errors.messages.customers.uncheck') and return if params[:openid].blank?
			if params[:name].blank? || params[:identity].blank? || params[:phone].blank?
				redirect_to bound_customers_path(openid: params[:openid], path: params[:path]), alert: t('errors.messages.params_not_null') and return
			end
			customers = Customer.where(name: params[:name], identity: params[:identity], phone: params[:phone])
			if customers.present?
				member = Member.find_by_open_id params[:openid]
				customer = customers.first
				customer.member = member
				if params[:path].blank?
					redirect_to bound_customers_path(customer_id: customer.id), notice: t('successes.messages.customers.bound')
				else
					redirect_to params[:path] + "?customer_id=#{customer.id}", notice: t('successes.messages.customers.bound')
				end
			end
		end
	end

end