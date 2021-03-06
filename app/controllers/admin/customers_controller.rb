class Admin::CustomersController < Admin::ApplicationController

  before_filter :add_breadcrumbs
  before_filter :find_customer, only: [:edit, :update, :destroy, :assign]

  def index
    # 授权
    authorize! :read, Customer, message: t('unauthorized.customer_read')
    
    respond_to do |format|
      format.html
      format.json do
        @data_tables = Customer.includes([:address]).to_datatable(self)
        render layout: false
      end
    end
  end

  def new
    # 授权
    authorize! :create, Customer, message: t('unauthorized.customer_create')
    
    add_breadcrumb :new
    @customer = Customer.new
  end

  def create
    # 授权
    authorize! :create, Customer, message: t('unauthorized.customer_create')
    
    @customer = Customer.new params[:customer]
    if @customer.save
      redirect_to admin_customers_path, notice: t('successes.messages.customers.create')
    else
      add_breadcrumb :new
      render :new
    end
  end

  def import
    # 授权
    authorize! :create, Customer, message: t('unauthorized.customer_import')
    
    @customer = Customer.new
    if request.get?
      add_breadcrumb :import
    else
      @customer.import_file = params[:customer][:import_file]
      message = @customer.import_excel_file
      if message.blank?
        redirect_to admin_customers_path, notice: t('successes.messages.customers.import')
      else
        redirect_to admin_customers_path, alert: message + t('errors.messages.customers.import')
      end
    end
  end

  def edit
    # 授权
    authorize! :update, Customer, message: t('unauthorized.customer_update')
    
    add_breadcrumb :edit
  end

  def update
    # 授权
    authorize! :update, Customer, message: t('unauthorized.customer_update')
    
    if @customer.update_attributes params[:customer]
      redirect_to admin_customers_path, notice: t('successes.messages.customers.update')
    else
      add_breadcrumb :edit
      render :edit
    end
  end

  def destroy
    # 授权
    authorize! :destroy, Customer, message: t('unauthorized.customer_destroy')
    
    if @customer.destroy
      redirect_to admin_customers_path, notice: t('successes.messages.customers.destroy')
    else
      redirect_to admin_customers_path, alert: t('errors.messages.customers.destroy')
    end
  end
  
  def assign
    # 授权
    authorize! :assign, Customer, message: t('unauthorized.customer_assign')
    
    if request.put?
      @customer.update_attributes params[:customer]
    end
  end

  private
  def find_customer
    @customer =  Customer.find params[:id]
  end

  def add_breadcrumbs
    add_breadcrumb :index, admin_customers_path
  end
end
