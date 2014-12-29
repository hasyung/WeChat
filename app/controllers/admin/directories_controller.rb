class Admin::DirectoriesController < Admin::ApplicationController

  before_filter :add_breadcrumbs
  before_filter :find_directory, only: [:edit, :update, :destroy]
  before_filter :restrictive_destroy, only: [:destroy]

  def index
    # 授权
    authorize! :read, Directory, message: t('unauthorized.directory_read')
    
    respond_to do |format|
      format.html
      format.json do
        @data_tables = current_account.directories.to_datatable(self)
        render layout: false
      end
    end
  end

  def new
    # 授权
    authorize! :create, Directory, message: t('unauthorized.directory_create')
    
    respond_to do |format|
      format.js { @directory = current_account.directories.new }
    end
  end

  def create
    # 授权
    authorize! :create, Directory, message: t('unauthorized.directory_create')
    
    @directory = current_account.directories.new params[:directory]
    respond_to do |format|
      format.js { @directory.save }
    end
  end

  def edit
    # 授权
    authorize! :update, Directory, message: t('unauthorized.directory_update')
    
    respond_to do |format|
      format.js { render 'new' }
    end
  end

  def update
    # 授权
    authorize! :update, Directory, message: t('unauthorized.directory_update')
    
    respond_to do |format|
      format.js do
        @directory.update_attributes params[:directory]
        render 'create'
      end
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

  private

  def find_directory
    @directory = current_account.directories.find params[:id]
    raise ActiveRecord::RecordNotFound unless @directory
  end

  def add_breadcrumbs
    add_breadcrumb I18n.t('breadcrumbs.admin.application.index'), \
      admin_directories_path
    add_breadcrumb :index, admin_directories_path
  end

  def restrictive_destroy
    if @directory.audios.present? or @directory.videos.present? or @directory.articles.present? or @directory.albums.present?
      redirect_to admin_directories_path, alert: t('errors.messages.directory.has_resources')
    end
  end
end
