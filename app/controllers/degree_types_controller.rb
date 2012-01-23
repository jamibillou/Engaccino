class DegreeTypesController < ApplicationController
  
  respond_to :json
  
  def update
    @degree_type = DegreeType.find(params[:id])
    @degree_type.update_attributes(params[:degree_type])
    respond_to do |format|
      format.json { respond_with_bip(@degree_type) }
    end    
  end
end
