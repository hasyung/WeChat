class Weixin::KitsController < Weixin::ApplicationController

	def index
		@parent = Directory.find params[:directory_id]
		@models = @parent.kits.includes([:kit_profile, :images, :directory_kits]).group_by{|m| m.kit_profile.category_cd }
	end

	def show
		@model = Kit.includes([:kit_profile, :images]).find params[:id]
		@customer = Customer.includes(:address).find params[:customer_id]
	end

end