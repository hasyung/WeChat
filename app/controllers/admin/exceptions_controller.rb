class Admin::ExceptionsController < Admin::ApplicationController
  
  skip_authorization_check
  
  layout 'admin/exception'
  
  def unauthorized
    
  end
  
end
