class MerchantsController < ApplicationController
  
   def index
    @account = Account.find_by_alias params[:alias]
    @merchants = @account.merchants.page(params[:page]).per(10)
    @count = @account.merchants.count if params[:page].to_i <= 1
  end

  def show
    @merchant = Merchant.find params[:id]
  end

end
