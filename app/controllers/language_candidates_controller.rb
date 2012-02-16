class LanguageCandidatesController < ApplicationController
  
  def new
    @language_candidate = LanguageCandidate.new
    @language_candidate.build_language
    render :partial => 'new_form'
  end
  
  def create
    @language_candidate = LanguageCandidate.new(params[:language_candidate])
    @language_candidate.candidate = current_user
    unless @language_candidate.save
      respond_to { |format| format.html { render :json => @language_candidate.errors, :status => :unprocessable_entity if request.xhr? } }
    else
      respond_to { |format| format.html { render :json => 'create!' if request.xhr? } }
    end    
  end
  
  def edit
    render :partial => 'edit_form', :locals => { :language_candidate => LanguageCandidate.find(params[:id]) }
  end
  
  def update
    @language_candidate = LanguageCandidate.find(params[:id])
    unless @language_candidate.update_attributes(params[:language_candidate])
      respond_to { |format| format.html { render :json => @language_candidate.errors, :status => :unprocessable_entity if request.xhr? } }
    else
      respond_to { |format| format.html { render :json => 'update!' if request.xhr? } }
    end  
  end
  
  def destroy
    language_candidate = LanguageCandidate.find(params[:id]) ; candidate = language_candidate.candidate
    language_candidate.destroy
    respond_to { |format| format.html { render :json => 'destroy!' if request.xhr? } }
  end
end
