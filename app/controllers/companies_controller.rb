class CompaniesController < ApplicationController
  
  respond_to :html, :json
  
  before_filter :authenticate
  before_filter :authorized, :signed_up, :only => [:show]
  
  def show
    @company  = Company.find params[:id]
    @title    = @company.name
    init_page :javascripts => 'companies/show'
  end
  
  def update
    @company = Company.find params[:id]
    unless @company.update_attributes params[:company]
      respond_to { |format| format.js { render :json => error_messages(@candidate) } if remotipart_submitted? }  
    else
      respond_to do |format|
        format.js   { render :json => 'success!' } if remotipart_submitted?
        format.json { respond_with_bip @company }
      end
    end    
  end
  
  def up_picture
    @company  = Company.find params[:id]
    render :partial => "companies/up_picture"
  end  
end