class DegreeTypesController < ApplicationController
  
  before_filter :authenticate
  
  respond_to :json
  
  def update
    @degree_type = DegreeType.find params[:id]
    @degree_type.update_attributes params[:degree_type]
    respond_to { |format| format.json { respond_with_bip @degree_type } }
  end
end
