class Admin::WeathersController < Admin::ApplicationController
  add_breadcrumb :index, :admin_weathers_path

  def index
    # 授权
    authorize! :read, Weather, message: t('unauthorized.weather_read')
    
    respond_to do |format|
      format.html
      format.json do
        @data_tables = current_account.weathers.to_datatable(self)
        render layout: false
      end
    end
  end

  def new
    # 授权
    authorize! :create, Weather, message: t('unauthorized.weather_create')
    
    add_breadcrumb :new
    @weather = current_account.weathers.new
  end

  def create
    # 授权
    authorize! :create, Weather, message: t('unauthorized.weather_create')
    
    @weather = current_account.weathers.new params[:weather]
    @weather.body = set_json
    if @weather.save
      redirect_to admin_weathers_path, notice: t('successes.messages.weathers.create')
    else
      add_breadcrumb :new
      render :new
    end
  end

  def edit
    # 授权
    authorize! :update, Weather, message: t('unauthorized.weather_update')
    
    add_breadcrumb :edit
    @weather = Weather.find params[:id]
    @weather.get_json
  end

  def update
    # 授权
    authorize! :update, Weather, message: t('unauthorized.weather_update')
    
    @weather = Weather.find params[:id]
    @weather.body = set_json
    if @weather.update_attributes params[:weather]
      redirect_to admin_weathers_path, notice: t('successes.messages.weathers.update')
    else
      add_breadcrumb :edit
      render :edit
    end
  end

  def destroy
    # 授权
    authorize! :destroy, Weather, message: t('unauthorized.weather_destroy')
    
    @weather = Weather.find params[:id]
    if @weather.destroy
      redirect_to admin_weathers_path, notice: t('successes.messages.weathers.destroy')
    else
      redirect_to admin_weathers_path, alert: t('errors.messages.weathers.destroy')
    end
  end

  private
  def set_json
    {
      "CITYID" => params[:weather][:cityid],
      "W1" => params[:weather][:w1],
      "W2" => params[:weather][:w2],
      "WT" => params[:weather][:wt],
      "ID" => params[:weather][:weather_id],
      "CITY" => params[:weather][:city],
      "T1" => params[:weather][:t1],
      "STRDATE" => params[:weather][:strdate],
      "WIND" => params[:weather][:wind],
      "RESOURCECODE" => params[:weather][:resourcecode],
      "T2" => params[:weather][:t2],
      "FH" => params[:weather][:fh],
    }.to_json
  end

end