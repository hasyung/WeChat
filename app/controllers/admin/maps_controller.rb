class Admin::MapsController < Admin::ApplicationController
  
  before_filter :find_map, only: [:edit, :update, :destroy, :assign]
  before_filter :add_breadcrumbs

  def index
    # 授权
    authorize! :read, Map, message: t('unauthorized.map_read')
    
    respond_to do |format|
      format.html
      format.json do
        @data_tables = current_account.maps.includes([:directory, :map_profile]).to_datatable(self)
        render layout: false
      end
    end
  end

  def new
    # 授权
    authorize! :create, Map, message: t('unauthorized.map_create')
    
    add_breadcrumb :new
    @map = current_account.maps.new
  end

  def create
    # 授权
    authorize! :create, Map, message: t('unauthorized.map_create')
    
    add_breadcrumb :new
    @map = current_account.maps.new params[:map]
    if @map.save
      redirect_to admin_maps_path, notice: t('successes.messages.maps.create')
    else
      render :new
    end
  end

  def edit
    # 授权
    authorize! :update, @map, message: t('unauthorized.map_update')
    
    add_breadcrumb :edit
  end

  def update
    # 授权
    authorize! :update, @map, message: t('unauthorized.map_update')
    
    if @map.update_attributes params[:map]
      redirect_to admin_maps_path, notice: t('successes.messages.maps.update')
    else
      add_breadcrumb :edit
      render :edit
    end
  end

  def destroy
    # 授权
    authorize! :destroy, @map, message: t('unauthorized.map_destroy')
    
    if @map.destroy
      redirect_to admin_maps_path, notice: t('successes.messages.maps.destroy')
    else
      redirect_to admin_maps_path, alert: t('errors.messages.maps.destroy')
    end
  end
  
  def assign
    # 授权
    authorize! :assign, Map, message: t('unauthorized.map_assign')
    
    if request.put?
      @map.update_attributes params[:map]
    end
  end

  private

  def find_map
    @map = current_account.maps.find params[:id]
    raise ActiveRecord::RecordNotFound unless @map
  end

  def add_breadcrumbs
    add_breadcrumb I18n.t('breadcrumbs.admin.resources.application.index'), admin_maps_path
    add_breadcrumb :index, admin_maps_path
  end
  
end
