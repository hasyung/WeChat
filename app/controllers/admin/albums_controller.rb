class Admin::AlbumsController < Admin::ApplicationController

  before_filter :add_breadcrumbs
  before_filter :find_album, only: [:edit, :update, :destroy, :images_sort, :assign]
  
  skip_authorization_check only: [:images_sort]

  def index
    # 授权
    authorize! :read, Album, message: t('unauthorized.album_read')
    
    respond_to do |format|
      format.html
      format.json do
        @data_tables = current_account.albums.to_datatable(self)
        render layout: false
      end
    end
  end

  def new
    # 授权
    authorize! :create, Album, message: t('unauthorized.album_create')
    
    add_breadcrumb :new
    @album = current_account.albums.new
  end

  def create
    # 授权
    authorize! :create, Album, message: t('unauthorized.album_create')
    
    @album = current_account.albums.new params[:album]
    if @album.save
      redirect_to admin_albums_path, notice: t('successes.messages.albums.create')
    else
      render :new
    end
  end

  def edit
    # 授权
    authorize! :update, @album, message: t('unauthorized.album_update')
    
    add_breadcrumb :edit
  end

  def update
    # 授权
    authorize! :update, @album, message: t('unauthorized.album_update')
    
    if @album.update_attributes params[:album]
      redirect_to admin_albums_path, notice: t('successes.messages.albums.update')
    else
      render :new
    end
  end

  def destroy
    # 授权
    authorize! :destroy, @album, message: t('unauthorized.album_destroy')
    
    if @album.destroy
      redirect_to admin_albums_path, notice: t('successes.messages.albums.destroy')
    else
      redirect_to admin_albums_path, alert: t('errors.messages.albums.destroy')
    end
  end

  def images_sort
    @images = @album.images
    params[:album][:image_ids].each_with_index do |id, index|
      Image.update_all({ order: index + 1 }, { album_id: @album.id, id: id })
    end
  end
  
  def assign
    # 授权
    authorize! :assign, Album, message: t('unauthorized.album_assign')
    
    if request.put?
      @album.update_attributes params[:album]
    end
  end

  private
  def add_breadcrumbs
    add_breadcrumb I18n.t('breadcrumbs.admin.resources.application.index'), admin_albums_path
    add_breadcrumb :index, :admin_albums_path
  end

  def find_album
    @album = current_account.albums.find params[:id]
  end
end
