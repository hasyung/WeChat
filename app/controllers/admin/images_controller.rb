class Admin::ImagesController < Admin::ApplicationController
  before_filter :find_album
  before_filter :find_image, only: [:edit, :update]
  
  skip_authorization_check

  def index
    @images = @album.images
    respond_to do |format|
      format.js
      format.json { render layout: false }
    end
  end

  def list
    respond_to do |format|
      format.html
      format.json do
        @data_tables = @album.images.to_datatable(self)
        render layout: false
      end
    end
  end

  def update
    if @image.update_attributes params[:image]
      @images = @album.images
      render :create
    else
      render :edit
    end
  end

  def create
    @image = @album.images.new params[:image]
    @image.file = params[:image][:file]
    respond_to do |format|
      if @image.save
        @images = @album.images
        format.json{ render layout: false }
        format.js
      else
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    image = @album.images.find params[:id]
    image.destroy
    @images = @album.images
    respond_to do |format|
      format.js { render :create }
    end
  end

  private
  def find_album
    @album = current_account.albums.find params[:album_id]
  end

  def find_image
    @image = @album.images.find_by_id params[:id]
  end

end
