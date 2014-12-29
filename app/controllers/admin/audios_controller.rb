class Admin::AudiosController < Admin::ApplicationController
  
  before_filter :find_audio, only: [:edit, :update, :destroy, :assign]
  before_filter :add_breadcrumbs

  def index
    # 授权
    authorize! :read, Audio, message: t('unauthorized.audio_read')
    
    respond_to do |format|
      format.html
      format.json do
        @data_tables = current_account.audios.includes([:directory, :audio_profile])
        @data_tables = @data_tables.where(admin_user_id: current_admin_user.id) if cannot? :manage, Audio
        @data_tables = @data_tables.to_datatable(self)
        render layout: false
      end
    end
  end

  def new
    # 授权
    authorize! :create, Audio, message: t('unauthorized.audio_create')
    
    add_breadcrumb :new
    @audio = current_account.audios.new
  end

  def create
    # 授权
    authorize! :create, Audio, message: t('unauthorized.audio_create')
    
    add_breadcrumb :new
    @audio = current_account.audios.new params[:audio]
    if @audio.save
      redirect_to admin_audios_path, notice: t('successes.messages.audios.create')
    else
      render :new
    end
  end

  def edit
    # 授权
    authorize! :update, @audio, message: t('unauthorized.audio_update')
    
    add_breadcrumb :edit
  end

  def update
    # 授权
    authorize! :update, @audio, message: t('unauthorized.audio_update')
    
    if @audio.update_attributes params[:audio]
      redirect_to admin_audios_path, notice: t('successes.messages.audios.update')
    else
      add_breadcrumb :edit
      render :edit
    end
  end

  def destroy
    # 授权
    authorize! :destroy, @audio, message: t('unauthorized.audio_destroy')
    
    if @audio.destroy
      redirect_to admin_audios_path, notice: t('successes.messages.audios.destroy')
    else
      redirect_to admin_audios_path, alert: t('errors.messages.audios.destroy')
    end
  end
  
  def assign
    # 授权
    authorize! :assign, Audio, message: t('unauthorized.audio_assign')
    
    if request.put?
      @audio.update_attributes params[:audio]
    end
  end

  private

  def find_audio
    @audio = current_account.audios.find params[:id]
    raise ActiveRecord::RecordNotFound unless @audio
  end

  def add_breadcrumbs
    add_breadcrumb I18n.t('breadcrumbs.admin.resources.application.index'), admin_audios_path
    add_breadcrumb :index, admin_audios_path
  end
  
end
