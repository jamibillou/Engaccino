class CompaniesController < ApplicationController
  respond_to :json
  
  def update
    @company = Company.find(params[:id])
    @company.update_attributes(params[:company])
    respond_to do |format|
      format.json { respond_with_bip(@company) }
    end    
  end
end