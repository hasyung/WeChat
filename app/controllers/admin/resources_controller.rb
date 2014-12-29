class Admin::ResourcesController < Admin::ApplicationController
  
  skip_authorization_check
  
  respond_to :js
  
  def index
    @data_tables = current_account.resources.to_datatable(self)
    render layout: false
  end
  
end
