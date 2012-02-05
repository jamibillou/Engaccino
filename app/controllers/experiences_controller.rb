class ExperiencesController < ApplicationController
  
  respond_to :json, :html
  
  def edit
    render :partial => 'edit_form', :locals => { :experience => Experience.find(params[:id]) }
  end
  
  def update
    @experience = Experience.find(params[:id])
    unless @experience.update_attributes(params[:experience])
      respond_to do |format|
        format.html { render :json => @experience.errors, :status => :unprocessable_entity if request.xhr? }
      end
    else
      respond_to do |format|
        format.html { render :json => "Everything is ok" if request.xhr? } 
      end        
    end  
  end
  
  def destroy
   experience = Experience.find(params[:id]) ; candidate = experience.candidate
   if experience.destroy
     respond_to do |format|
       format.html { render :json => "Everything is ok" if request.xhr? }
       format.js
     end
   end   
  end
end
