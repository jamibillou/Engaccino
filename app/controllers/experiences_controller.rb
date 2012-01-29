class ExperiencesController < ApplicationController
  
  respond_to :json, :html
  
  def edit
    experience = Experience.find(params[:id])
    render :partial => 'edit_form', :locals => {:experience => experience}
  end
  
  def update
    @experience = Experience.find(params[:id])
    unless @experience.update_attributes(params[:experience])
      respond_to do |format|
        format.html do
          if request.xhr? then render :json => @experience.errors, :status => :unprocessable_entity end
        end
      end
    else
      respond_to do |format|
        format.json do
          respond_with_bip(@experience)
        end
        format.html do
          if request.xhr? then render :json => "OK", :status => :success end
        end
      end  
    end  
  end
  
end
