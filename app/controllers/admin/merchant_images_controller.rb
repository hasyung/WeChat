class Admin::MerchantImagesController < Admin::ApplicationController
  before_filter :find_merchant
  before_filter :find_image, only: [:edit, :update]

  skip_authorization_check

  def index
    @images = @merchant.merchant_images
    respond_to do |format|
      format.js
      format.json { render layout: false }
    end
  end

  def list
    respond_to do |format|
      format.html
      format.json do
        @data_tables = @merchant.merchant_images.to_datatable(self)
        render layout: false
      end
    end
  end

  def update
    if @image.update_attributes params[:merchant_image]
      @images = @merchant.merchant_images
      render :create
    else
      render :edit
    end
  end

  def create
    @image = @merchant.merchant_images.new params[:merchant_image]
    @image.file = params[:merchant_image][:file]
    respond_to do |format|
      if @image.save
        @images = @merchant.merchant_images
        format.json{ render layout: false }
        format.js
      else
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    image = @merchant.merchant_images.find params[:id]
    image.destroy
    @images = @merchant.merchant_images
    respond_to do |format|
      format.js { render :create }
    end
  end

  private
  def find_merchant
    @merchant = current_account.merchants.find params[:merchant_id]
  end

  def find_image
    @image = @merchant.merchant_images.find_by_id params[:id]
  end

end
