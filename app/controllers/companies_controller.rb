class CompaniesController < ApplicationController
  
  respond_to :html, :json
  
  before_filter :authenticate
  before_filter :authorized, :signed_up, :only => [:show]
  
  def show
    @company  = Company.find params[:id]
    @title    = @company.name
    # @location = @company.to_gmaps4rails
    init_page :javascripts => 'companies/show'
  end
  
  def update
    @company = Company.find params[:id]
    @company.update_attributes params[:company]
    respond_to { |format| format.json { respond_with_bip @company } }
  end
  
  private
  
    def signed_up
      redirect_to edit_candidate_path(current_user), :notice => t('flash.notice.please_finish_signup') unless signed_up?
    end
end