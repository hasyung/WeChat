class Admin::ApplicationController < ActionController::Base
  # add_breadcrumb :index, :admin_root_path
  
  before_filter :authenticate_admin_user!
  before_filter :authenticate_account!
  before_filter :current_account_breadcrumb
  
  helper_method :current_account
  
  check_authorization
  
  def current_account
    @current_account ||= Account.first
  end
  
  def authenticate_account!
    redirect_to admin_root_path, alert: t('errors.messages.accounts.empty') if current_account.blank?
  end
  
  def current_account_breadcrumb
    add_breadcrumb current_account.name, :admin_root_path if current_account.present?
  end
  
  def current_ability
    @current_ability ||= Ability.new(current_admin_user)
  end
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to unauthorized_admin_exceptions_path, alert: exception.message
  end
  
end
