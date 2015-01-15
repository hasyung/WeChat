class IndentsController < ApplicationController

	def index
	end

	def show
		@model = params[:controller].to_s.classify.constantize.find params[:id]
	end

end