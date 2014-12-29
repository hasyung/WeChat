class Admin::SystemRepliesController < Admin::ApplicationController
  
  add_breadcrumb I18n.t('breadcrumbs.admin.application.settings.index'), :admin_system_replies_path
  add_breadcrumb :index, :admin_system_replies_path
  
  def index
    # 授权
    authorize! :system, Reply, message: t('unauthorized.system_reply_read')
    
    @replies = current_account.replies.is_system.page(params[:page]).per(Setting.page_size)
    if params[:reply].blank?
      @filter = Reply.new
    else
      @filter = Reply.new params[:reply]
      build_filters(params[:reply]).each { |array| @replies = @replies.where array }
    end
    render 'admin/replies/index'
  end
  
end
