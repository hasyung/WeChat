class IndentsController < ApplicationController

	def index
		@models = Indent.includes(:kit, :directory).group_by{|m| m.directory.title}
	end

	def show
		@model = Indent.includes(:kit, :directory).find params[:id]
		# @customer = Customer.includes(:address).find params[:customer_id]
		 @customer = Customer.includes(:address).find 1
	end

	def create
	    @indent = Indent.new
	    @indent.customer_id = params[:customer_id]
	    @indent.kit_id = params[:kit_id]
	    @indent.directory_id = params[:directory_id]
	    @indent.item_count = params[:item_count]
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