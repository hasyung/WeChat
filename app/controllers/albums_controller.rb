class AlbumsController < ApplicationController

  def index
    @account = Account.find_by_alias params[:alias]
    @albums =  @account.albums.includes([:album_profile, :images]).where('album_profiles.type_cd = ?', params[:type_cd]).page(params[:page]).per(10)
    @count =  @account.albums.includes(:album_profile).where('album_profiles.type_cd = ?', params[:type_cd]).count if params[:page].to_i <= 1
  end

  def show
    @album = Album.find params[:id]
  end

end
