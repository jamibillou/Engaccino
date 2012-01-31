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
          render :json => @experience.errors, :status => :unprocessable_entity if request.xhr?
        end
      end
    else
      respond_to do |format|
        format.html do
          render :json => "Everything is ok" if request.xhr?
        end
      end        
    end  
  end
  
end
