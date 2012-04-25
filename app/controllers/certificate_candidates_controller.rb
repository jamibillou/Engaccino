class CertificateCandidatesController < ApplicationController
  
  before_filter :authenticate
  before_filter :ajax_only, :only => [:new, :edit]
  
  def new
    @certificate_candidate = CertificateCandidate.new
    @certificate_candidate.build_certificate
    render :partial => 'new_form'
  end
    
  def create
    @certificate_candidate = CertificateCandidate.new params[:certificate_candidate]
    @certificate_candidate.candidate = current_user
    unless @certificate_candidate.save
      respond_to { |format| format.html { render :json => @certificate_candidate.errors, :status => :unprocessable_entity if request.xhr? } }
    else
      respond_to { |format| format.html { render :json => 'create!' if request.xhr? } }
    end    
  end
  
  def edit
    render :partial => 'edit_form', :locals => { :certificate_candidate => CertificateCandidate.find(params[:id]) }
  end
  
  def update
    @certificate_candidate = CertificateCandidate.find params[:id]
    unless @certificate_candidate.update_attributes params[:certificate_candidate]
      respond_to { |format| format.html { render :json => @certificate_candidate.errors, :status => :unprocessable_entity if request.xhr? } }
    else
      respond_to { |format| format.html { render :json => 'update!' if request.xhr? } }
    end  
  end
  
  def destroy
    CertificateCandidate.find(params[:id]).destroy
    respond_to { |format| format.html { render :json => 'destroy!' if request.xhr? } }
  end
  
end
