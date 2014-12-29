class Admin::KitsController < Admin::ApplicationController
  before_filter :add_breadcrumbs
  before_filter :find_kit, only: [:edit, :update, :destroy, :assign]

  def index
    # 授权
    authorize! :read, Kit, message: t('unauthorized.kit_read')
    
    respond_to do |format|
      format.html
      format.json do
        @data_tables = current_account.kits.includes([:kit_profile])
        @data_tables = @data_tables.where(admin_user_id: current_admin_user.id) if cannot? :manage, kit
        @data_tables = @data_tables.to_datatable(self)
        render layout: false
      end
    end
  end

  def new
    # 授权
    authorize! :create, Kit, message: t('unauthorized.kit_create')
    
    add_breadcrumb :new
    @kit = current_account.kits.new
  end

  def create
    # 授权
    authorize! :create, Kit, message: t('unauthorized.kit_create')
    
    @kit = current_account.kits.new params[:kit]
    if @kit.save
      redirect_to admin_kits_path, notice: t('successes.messages.kits.create')
    else
      add_breadcrumb :new
      render :new
    end
  end

  def edit
    # 授权
    authorize! :update, @kit, message: t('unauthorized.kit_update')
    
    add_breadcrumb :edit
  end

  def update
    # 授权
    authorize! :update, @kit, message: t('unauthorized.kit_update')
    
    if @kit.update_attributes params[:kit]
      redirect_to admin_kits_path, notice: t('successes.messages.kits.update')
    else
      add_breadcrumb :edit
      render :edit
    end
  end

  def destroy
    # 授权
    authorize! :destroy, @kit, message: t('unauthorized.kit_destroy')
    
    if @kit.destroy
      redirect_to admin_kits_path, notice: t('successes.messages.kits.destroy')
    else
      redirect_to admin_kits_path, alert: t('errors.messages.kits.destroy')
    end
  end
  
  def assign
    # 授权
    authorize! :assign, Kit, message: t('unauthorized.kit_assign')
    
    if request.put?
      @kit.update_attributes params[:kit]
    end
  end

  private
  def find_kit
    @kit =  current_account.kits.find params[:id]
  end

  def add_breadcrumbs
    add_breadcrumb I18n.t('breadcrumbs.admin.resources.application.index'), admin_kits_path
    add_breadcrumb :index, admin_kits_path
  end
end
