class Admin::AccountsController < Admin::ApplicationController

  before_filter :find_account, only: [:edit, :update, :menus]

  def edit
    # 授权
    authorize! :update, Account, message: t('unauthorized.account_update')
    add_breadcrumb :edit
  end

  def update
    # 授权
    authorize! :update, Account, message: t('unauthorized.account_update')
    @account.update_attributes params[:account]
  end
  
  def menus
    # 授权
    authorize! :manage, Menu, message: t('unauthorized.menu_manage')
    
    respond_to do |format|
      format.js do
        if @account.is_complete?
          @result = @account.create_menus if request.post?
          @result = @account.get_menus if request.get?
          @result = @account.destroy_menus if request.delete?
        end
      end
    end
  end

  private
  def find_account
    @account = Account.find params[:id]
  end

end
