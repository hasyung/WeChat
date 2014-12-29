class Admin::AdminUsers::SessionsController < Devise::SessionsController
  
  skip_before_filter :require_no_authentication, :only => [:new]
  
  layout 'blank'

  def create
    if valid_captcha?(params[:admin_user][:captcha])
      audited
      super
    else
      # build_resource
      self.resource = AdminUser.new params[:admin_user]
      flash[:error] = t('devise.failure.captcha_error')
      # clear captcha
      self.resource.captcha = ''
      respond_with_navigational(self.resource) { render :new }
    end
  end

  def destroy
    audited
    super
  end

  protected
  def audited
    return if current_admin_user.blank?
    action = request.post? ? "login" : "logout"
    count = Audit.where(action: action, auditable_id: current_admin_user.id).count
    Audit.create auditable_id: current_admin_user.id, auditable_type: "AdminUser", action: action, version: count, remote_address: request.remote_ip, user_id: current_admin_user.id, user_type: "AdminUser"
  end

end
