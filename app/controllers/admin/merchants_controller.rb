class Admin::MerchantsController < Admin::ApplicationController

  before_filter :add_breadcrumbs
  before_filter :find_merchant, only: [:edit, :update, :destroy, :images_sort, :assign]

  skip_authorization_check only: [:images_sort]

  def index
    # 授权
    authorize! :read, Merchant, message: t('unauthorized.merchant_read')

    respond_to do |format|
      format.html
      format.json do
        @data_tables = current_account.merchants.to_datatable(self)
        render layout: false
      end
    end
  end

  def new
    # 授权
    authorize! :create, Merchant, message: t('unauthorized.merchant_create')

    add_breadcrumb :new
    @merchant = current_account.merchants.new
  end

  def create
    # 授权
    authorize! :create, Merchant, message: t('unauthorized.merchant_create')

    @merchant = current_account.merchants.new params[:merchant]
    if @merchant.save
      redirect_to admin_merchants_path, notice: t('successes.messages.merchants.create')
    else
      render :new
    end
  end

  def edit
    # 授权
    authorize! :update, @merchant, message: t('unauthorized.merchant_update')

    add_breadcrumb :edit
  end

  def update
    # 授权
    authorize! :update, @merchant, message: t('unauthorized.merchant_update')

    if @merchant.update_attributes params[:merchant]
      redirect_to admin_merchants_path, notice: t('successes.messages.merchants.update')
    else
      render :new
    end
  end

  def destroy
    # 授权
    authorize! :destroy, @merchant, message: t('unauthorized.merchant_destroy')

    if @merchant.destroy
      redirect_to admin_merchants_path, notice: t('successes.messages.merchants.destroy')
    else
      redirect_to admin_merchants_path, alert: t('errors.messages.merchants.destroy')
    end
  end

  def images_sort
    @images = @merchant.merchant_images
    params[:merchant][:merchant_image_ids].each_with_index do |id, index|
      MerchantImage.update_all({ order: index + 1 }, { merchant_id: @merchant.id, id: id })
    end
  end

  def assign
    # 授权
    authorize! :assign, Merchant, message: t('unauthorized.merchant_assign')

    if request.put?
      @merchant.update_attributes params[:merchant]
    end
  end

  private
  def add_breadcrumbs
    add_breadcrumb I18n.t('breadcrumbs.admin.resources.application.index'), admin_merchants_path
    add_breadcrumb :index, :admin_merchants_path
  end

  def find_merchant
    @merchant = current_account.merchants.find params[:id]
  end
end
