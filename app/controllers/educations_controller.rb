class EducationsController < ApplicationController
  
  respond_to :json, :html
  
  def edit
    render :partial, 'edit_form', :locals => { :education => Education.find(params[:id]) }
  end
  
  def update
    @education = Education.find(params[:id])
    unless @education.update_attributes(params[:education])
      respond_to do |format|
        format.html { render :json => @education.errors, :status => :unprocessable_entity if request.xhr? }
      end
    else
      respond_to do |format|
        format.html { render :json => "Everything is ok" if request.xhr? }
      end        
    end  
  end
  
  def destroy
    education = Education.find(params[:id]) ; candidate = education.candidate
    education.destroy
    respond_to do |format|
      format.html { render :json => "Delete ok" if request.xhr? }
    end
  end
end
