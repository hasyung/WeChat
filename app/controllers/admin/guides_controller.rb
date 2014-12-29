class Admin::GuidesController < Admin::ApplicationController
  add_breadcrumb :index, :admin_guides_path

  def index
    # 授权
    authorize! :read, Guide, message: t('unauthorized.guide_read')
    
    respond_to do |format|
      format.html
      format.json do
        @data_tables = current_account.guides.to_datatable(self)
        render layout: false
      end
    end
  end

  def new
    # 授权
    authorize! :create, Guide, message: t('unauthorized.guide_create')
    
    add_breadcrumb :new
    @guide = current_account.guides.new
  end

  def create
    # 授权
    authorize! :create, Guide, message: t('unauthorized.guide_create')
    
    @guide = current_account.guides.new params[:guide]
    @guide.body = set_json
    if @guide.save
      redirect_to admin_guides_path, notice: t('successes.messages.guides.create')
    else
      add_breadcrumb :new
      render :new
    end
  end

  def edit
    # 授权
    authorize! :update, Guide, message: t('unauthorized.guide_update')
    
    add_breadcrumb :edit
    @guide = Guide.find params[:id]
    @guide.get_json
  end

  def update
    # 授权
    authorize! :update, Guide, message: t('unauthorized.guide_update')
    
    @guide = Guide.find params[:id]
    @guide.body = set_json
    if @guide.update_attributes params[:guide]
      redirect_to admin_guides_path, notice: t('successes.messages.guides.update')
    else
      add_breadcrumb :edit
      render :edit
    end
  end

  def destroy
    # 授权
    authorize! :destroy, Guide, message: t('unauthorized.guide_destroy')
    
    @guide = Guide.find params[:id]
    if @guide.destroy
      redirect_to admin_guides_path, notice: t('successes.messages.guides.destroy')
    else
      redirect_to admin_guides_path, alert: t('errors.messages.guides.destroy')
    end
  end

  def search
    # 授权
    authorize! :read, Guide, message: t('unauthorized.guide_read')
    
    add_breadcrumb :index
    add_breadcrumb params[:guide][:name]
    if params[:guide][:name].blank?
      redirect_to admin_guides_path, :alert => t("errors.messages.guides.search_error")
      return
    else
      respond_to do |format|
        format.html
        format.json do
          @data_tables = Guide.search_name(params[:guide][:name]).to_datatable(self)
          render layout: false
        end
      end
    end
  end

  private
  def set_json
    {
      "COMPANY" => params[:guide][:company],
      "TYPENAME" => params[:guide][:typename],
      "LANGUAGE" => params[:guide][:language],
      "GENDER" => params[:guide][:gender],
      "AREACODE" => params[:guide][:areacode],
      "RN" => params[:guide][:rn],
      "IDNO" => params[:guide][:idno],
      "REGIONNAME" => params[:guide][:regionname],
      "MEMO" => params[:guide][:memo],
      "GUIDEIDCARD" => params[:guide][:guideidcard],
      "ID" => params[:guide][:guide_id],
      "IDENTIFICATION" => params[:guide][:identification],
      "GUIDELEVEL" => params[:guide][:guidelevel],
      "GUIDEIMAGE" => params[:guide][:guideimage],
    }.to_json
  end

end