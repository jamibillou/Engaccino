class EducationsController < ApplicationController
  
  respond_to :json, :html
  
  def edit
    @education = Education.find(params[:id])
    render :partial, 'edit_form', :locals => {:education => @education}
  end
  
  def update
    @education = Education.find(params[:id])
    unless @education.update_attributes(params[:education])
      respond_to do |format|
        format.html do
          render :json => @education.errors, :status => :unprocessable_entity if request.xhr?
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
