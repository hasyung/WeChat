class Admin::MessagesController < Admin::ApplicationController
  
  add_breadcrumb :index, :admin_messages_path
  
  def index
    # 授权
    authorize! :read, Message, message: t('unauthorized.message_read')
    
    respond_to do |format|
      format.html
      format.json do
        @data_tables = Message.includes(:member).where(['`members`.`account_id` = ?', current_account])
        .order('`messages`.`id` DESC').to_datatable(self)
        render layout: false
      end
    end
  end

  def show
    # 授权
    authorize! :read, Message, message: t('unauthorized.message_read')
    
    add_breadcrumb :show
    @message = Message.find params[:id]
  end
  
end
