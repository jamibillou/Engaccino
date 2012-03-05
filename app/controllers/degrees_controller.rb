class DegreesController < ApplicationController

  respond_to :json
  
  def update
    @degree = Degree.find params[:id]
    @degree.update_attributes params[:degree]
    respond_to { |format| format.json { respond_with_bip @degree } }
  end
end
