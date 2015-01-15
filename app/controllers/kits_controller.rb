class KitsController < ApplicationController

	def index
		@parent = Directory.find params[:directory_id]
		@models = @parent.kits.includes([:kit_profile, :images, :directory_kits])
	end

	def show
		@model = Kit.includes([:kit_profile, :images]).find params[:id]
	end

end