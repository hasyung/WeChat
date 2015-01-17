class CustomersController < ApplicationController
	before_filter :authenticate_customer!, except: [:bound]

	def bound
		if request.get?

		elsif request.post
		
		end
	end

end