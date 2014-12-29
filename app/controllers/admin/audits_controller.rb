class Admin::AuditsController < Admin::ApplicationController
  add_breadcrumb :index, :admin_audits_path

  def index
    # 授权
    authorize! :read, Audit, message: t('unauthorized.audit_read')
    
    respond_to do |format|
      format.html
      format.json do
        @data_tables = Audit.to_datatable(self)
        render layout: false
      end
    end
  end

  def show
    # 授权
    authorize! :read, Audit, message: t('unauthorized.audit_read')

    @audit = Audit.find params[:id]
  end

end