class Admin::HomeController < Admin::ApplicationController
  
  skip_authorization_check
  
  add_breadcrumb :index, :admin_root_path
  
  skip_before_filter :authenticate_account!
  
  def index
  end
  
  def account
    session[:current_account] = params[:account][:id] if params[:account][:id].present?
    redirect_to :back
  end
  
end
