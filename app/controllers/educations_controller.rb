class EducationsController < ApplicationController
  
  respond_to :json
  
  def edit
    @education = Education.find(params[:id])
    render :partial, 'edit_form', :locals => {:education => @education}
  end
  
  def update
    @education = Education.find(params[:id])
    @education.update_attributes(params[:education])
    respond_to do |format|
      format.json { respond_with_bip(@education) }
    end    
  end
end
