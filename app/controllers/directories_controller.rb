class DirectoriesController < ApplicationController

	def index
		@models = Directory.all
	end

	def show
		@model = Directory.find params[:id]
	end

end