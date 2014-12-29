class AudiosController < ApplicationController
  
  def show
    @audio = Audio.find params[:id]
  end
  
end

