class IndentsController < ApplicationController

	def index
		indents = Indent.includes(:kit, :directory).all
		@models = indents.group_by{|m| m.directory.title}
		change_models = indents.select{|m| m.type_cd == 3 && m.logistics_code.present? && (DateTime.now.to_i - m.created_at.to_i) >= Setting.kit_exprise_in}
		change_models.each do |model|
			model.update_attributes(type_cd: 4)
		end
	end

	def show
		@model = Indent.includes(:kit, :directory).find params[:id]
		@model.update_attributes(type_cd: 4) if @model.type_cd == 3 && @model.logistics_code.present? && (DateTime.now.to_i - @model.created_at.to_i) >= Setting.kit_exprise_in
		# @customer = Customer.includes(:address).find params[:customer_id]
		 @customer = Customer.includes(:address).find 1
	end

	def change
	    @indent = Indent.new customer_id: params[:customer_id], kit_id: params[:kit_id], directory_id: params[:directory_id], item_count: params[:item_count]
	    if @indent.save
	      redirect_to indents_path(customer_id: params[:customer_id]), notice: t('successes.messages.indent.create')
	    else
	      redirect_to directory_kit_path(params[:directory_id], params[:kit_id], customer_id: params[:customer_id]), alert: t('errors.messages.indent.create')
	    end
	end

	def unpass
		@model = Indent.find params[:id]
		@model.type_cd = 5
		if @model.save
			redirect_to indents_path(customer_id: params[:customer_id]), notice: t('successes.messages.indent.unpass')
		else
			redirect_to indents_path(customer_id: params[:customer_id]), alert: t('errors.messages.indent.unpass')
		end
	end
end