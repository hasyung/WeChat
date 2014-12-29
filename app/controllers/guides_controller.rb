class GuidesController < ApplicationController
  
  layout false

  def show
    @guide = Guide.find params[:id]
  end
end
