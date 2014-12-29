class Admin::MembersController < Admin::ApplicationController
  add_breadcrumb :index, :admin_members_path
  before_filter :find_member, only: [:info, :destroy]

  def index
    # 授权
    authorize! :read, Member, message: t('unauthorized.member_read')
    
    respond_to do |format|
      format.html
      format.json do
        @data_tables = current_account.members.to_datatable(self)
        render layout: false
      end
    end
  end

  def destroy
    # 授权
    authorize! :destroy, Member, message: t('unauthorized.member_destroy')
    
    if @member.destroy
      redirect_to admin_members_path, notice: t('successes.messages.members.destroy')
    else
      redirect_to admin_members_path, alert: t('errors.messages.members.destroy')
    end
  end
  
  def info
    respond_to do |format|
      format.js do
        @result = current_account.get_member_info(@member.open_id) if current_account.is_complete?
      end
    end
  end

  private
  def find_member
    @member = current_account.members.find params[:id]
  end
end
