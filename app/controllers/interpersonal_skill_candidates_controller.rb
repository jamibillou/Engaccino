class InterpersonalSkillCandidatesController < ApplicationController

  before_filter :authenticate
  before_filter :ajax_only, :only => [:new, :edit]
  
  def new
    @interpersonal_skill_candidate = InterpersonalSkillCandidate.new
    @interpersonal_skill_candidate.build_interpersonal_skill
    render :partial => 'new_form'
  end
    
  def create
    @interpersonal_skill_candidate = InterpersonalSkillCandidate.new params[:interpersonal_skill_candidate]
    @interpersonal_skill_candidate.candidate = current_user
    unless @interpersonal_skill_candidate.save
      respond_to { |format| format.html { render :json => @interpersonal_skill_candidate.errors, :status => :unprocessable_entity if request.xhr? } }
    else
      respond_to { |format| format.html { render :json => 'create!' if request.xhr? } }
    end    
  end
  
  def edit
    render :partial => 'edit_form', :locals => { :interpersonal_skill_candidate => InterpersonalSkillCandidate.find(params[:id]) }
  end
  
  def update
    @interpersonal_skill_candidate = InterpersonalSkillCandidate.find params[:id]
    unless @interpersonal_skill_candidate.update_attributes params[:interpersonal_skill_candidate]
      respond_to { |format| format.html { render :json => @interpersonal_skill_candidate.errors, :status => :unprocessable_entity if request.xhr? } }
    else
      respond_to { |format| format.html { render :json => 'update!' if request.xhr? } }
    end  
  end
  
  def destroy
    InterpersonalSkillCandidate.find(params[:id]).destroy
    respond_to { |format| format.html { render :json => 'destroy!' if request.xhr? } }
  end
  
end
