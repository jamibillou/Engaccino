class ExperiencesController < ApplicationController
  
  respond_to :json
  
  def edit
    @experience = Experience.find(params[:id])
    render :partial => 'edit_form'
  end
  
  def update
    @experience = Experience.find(params[:id])
    @experience.update_attributes(params[:experience])
    respond_to do |format|
      format.json { respond_with_bip(@experience) }
    end    
  end
end
