class Admin::MenusController < Admin::ApplicationController

  add_breadcrumb :index, :admin_menus_path

  before_filter :find_menu, only: [:show, :edit, :update, :destroy, :category, :resources]
  
  skip_authorization_check only: [:resources, :category, :sort]

  respond_to :js

  def index
    # 授权
    authorize! :read, Menu, message: t('unauthorized.menu_read')
    
    respond_to do |format|
      format.html
    end
  end

  def show
    # 授权
    authorize! :read, Menu, message: t('unauthorized.menu_read')
    
  end

  def category
    @menu.category_cd = params[:category_id] if params[:category_id].present?
  end

  def resources
    @resources = current_account.resources.where(id: params[:resource_ids]) if request.post?
  end

  def new
    # 授权
    authorize! :create, Menu, message: t('unauthorized.menu_create')
    
    respond_with do
      if params[:parent_id].blank?
        @menu = current_account.menus.new
      else
        @menu = current_account.menus.new parent_id: params[:parent_id]
      end
    end
  end


  def create
    # 授权
    authorize! :create, Menu, message: t('unauthorized.menu_create')
    
    @menu = current_account.menus.new params[:menu]
    respond_with @menu.save
  end

  def edit
    # 授权
    authorize! :update, Menu, message: t('unauthorized.menu_update')
    
    render :new
  end

  def update
    # 授权
    authorize! :update, Menu, message: t('unauthorized.menu_update')
    
    @menu.update_attributes params[:menu]
    params[:menu][:resource_ids].each_with_index do |id, index|
      MenuResource.update_all({ order: index + 1 }, { menu_id: @menu.id, resource_id: id })
    end if params[:menu][:resource_ids].present?
    render :create
  end

  def destroy
    # 授权
    authorize! :destroy, Menu, message: t('unauthorized.menu_destroy')
    
    respond_to do |format|
      format.js do
        @menu.update_attributes soft_delete: true
      end
    end
  end

  def sort
    params[:menu].each_with_index do |id, index|
      Menu.update_all({ order: index + 1 }, { id: id })
    end
    render nothing: true
  end

  private
  def find_menu
    @menu = current_account.menus.find params[:id]
    raise ActiveRecord::RecordNotFound unless @menu
  end
end
