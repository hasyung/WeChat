class Admin::AdminUsersController < Admin::ApplicationController

  add_breadcrumb :index, :admin_admin_users_path
  
  before_filter :find_admin_user, only: [:edit, :update, :destroy]
  
  skip_before_filter :authenticate_account!, only: [:setting]

  def index
    # 授权
    authorize! :read, AdminUser, message: t('unauthorized.admin_user_read')
    
    respond_to do |format|
      format.html
      format.json do
        @data_tables = AdminUser.to_datatable(self)
        render layout: false
      end
    end
  end
  
  def new
    # 授权
    authorize! :create, AdminUser, message: t('unauthorized.admin_user_create')
    
    add_breadcrumb :new
    @admin_user = AdminUser.new
  end
  
  def create
    # 授权
    authorize! :create, AdminUser, message: t('unauthorized.admin_user_create')
    
    @admin_user = AdminUser.new params[:admin_user]
    if @admin_user.save
      redirect_to admin_admin_users_path, notice: t('successes.messages.admin_users.create')
    else
      add_breadcrumb :new
      render :new
    end
  end
  
  def edit
    # 授权
    authorize! :update, @admin_user, message: t('unauthorized.admin_user_update')
    
    add_breadcrumb :edit
  end
  
  def update
    # 授权
    authorize! :update, @admin_user, message: t('unauthorized.admin_user_update')
    
    if params[:admin_user][:password].blank?
      params[:admin_user].delete(:password)
      params[:admin_user].delete(:password_confirmation)
    end
    if @admin_user.update_attributes params[:admin_user]
      redirect_to admin_admin_users_path, notice: t('successes.messages.admin_users.update')
    else
      add_breadcrumb :edit
      render :edit
    end
  end
  
  def destroy
    # 授权
    authorize! :destroy, @admin_user, message: t('unauthorized.admin_user_destroy')
    
    if @admin_user.destroy
      redirect_to admin_admin_users_path, notice: t('successes.messages.admin_users.destroy')
    else
      redirect_to admin_admin_users_path, alert: t('errors.messages.admin_users.destroy')
    end
  end

  def setting
    # 授权
    authorize! :admin_user_setting, current_admin_user, message: t('unauthorized.admin_user_setting')
    
    if request.post?
      if params[:admin_user][:password].present?
        result = current_admin_user.update_with_password params[:admin_user]
      else
        result = current_admin_user.update_without_password params[:admin_user]
      end

      if result
        redirect_to admin_root_path, notice: t('successes.messages.admin_user.update')
      else
        render :setting
      end
    end
  end
  
  private
  
  def find_admin_user
    @admin_user = AdminUser.find params[:id]
    raise ActiveRecord::RecordNotFound unless @admin_user
  end

end
