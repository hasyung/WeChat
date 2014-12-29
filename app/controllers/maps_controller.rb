class MapsController < ApplicationController
  
  layout false
  
  def index
    respond_to do |format|
      format.html { render layout: false }
      format.json do
        @replies = Reply.location.non_system
      end
    end
  end

  def show
    @map = Map.find params[:id]
  end
end
