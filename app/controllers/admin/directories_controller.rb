class Admin::DirectoriesController < Admin::ApplicationController

  before_filter :add_breadcrumbs
  before_filter :find_directory, only: [:edit, :update, :destroy, :assign]

  def index
    # 授权
    authorize! :read, Directory, message: t('unauthorized.directory_read')
    
    respond_to do |format|
      format.html
      format.json do
        @data_tables = current_account.directories.to_datatable(self)
        # @data_tables = @data_tables.where(admin_user_id: current_admin_user.id) if cannot? :manage, Directory
        # @data_tables = @data_tables.to_datatable(self)
        render layout: false
      end
    end
  end

  def new
    # 授权
    authorize! :create, Directory, message: t('unauthorized.directory_create')
    
    add_breadcrumb :new
    @directory = current_account.directories.new
  end

  def create
    # 授权
    authorize! :create, Directory, message: t('unauthorized.directory_create')
    
    @directory = current_account.directories.new params[:directory]
    if @directory.save && add_kits
      redirect_to admin_directories_path, notice: t('successes.messages.directory.create')
    else
      add_breadcrumb :new
      render :new
    end
  end

  def edit
    # 授权
    authorize! :update, Directory, message: t('unauthorized.directory_update')
    
    add_breadcrumb :edit
  end

  def update
    # 授权
    authorize! :update, Directory, message: t('unauthorized.directory_update')
    
    if @directory.update_attributes(params[:directory]) && add_kits
      redirect_to admin_directories_path, notice: t('successes.messages.directory.update')
    else
      redirect_to admin_directories_path, alert: t('errors.messages.directory.update')
    end
  end

  def destroy
    # 授权
    authorize! :destroy, Directory, message: t('unauthorized.directory_destroy')
    
    if @directory.destroy
      redirect_to admin_directories_path, notice: t('successes.messages.directory.destroy')
    else
      redirect_to admin_directories_path, alert: t('errors.messages.directory.destroy')
    end
  end

  def assign
    # 授权
    authorize! :assign, Directory, message: t('unauthorized.directory_assign')
    
    if request.put?
      @directory.update_attributes params[:directory]
    end
  end

  private

  def find_directory
    @directory = current_account.directories.find params[:id]
    raise ActiveRecord::RecordNotFound unless @directory
  end

  def add_kits
    params[:directory]["kits"].delete("")
    DirectoryKit.transaction do
      @directory.kits.clear
      params[:directory]["kits"].each{|kit_id|@directory.kits << Kit.find(kit_id)}
    end
  end

  def add_breadcrumbs
    add_breadcrumb I18n.t('breadcrumbs.admin.application.resources.index'), \
      admin_directories_path
    add_breadcrumb :index, admin_directories_path
  end
end
