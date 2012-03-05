class SchoolsController < ApplicationController
  
  respond_to :json
  
  def update
    @school = School.find params[:id]
    @school.update_attributes params[:school]
    respond_to { |format| format.json { respond_with_bip(@school) } }
  end
end

