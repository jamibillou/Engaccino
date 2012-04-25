class ProfessionalSkillCandidatesController < ApplicationController

  before_filter :authenticate
  before_filter :ajax_only, :only => [:new, :edit] 
  
  def new
    @professional_skill_candidate = ProfessionalSkillCandidate.new
    @professional_skill_candidate.build_professional_skill
    render :partial => 'new_form'
  end
  
  def create
    @professional_skill_candidate = ProfessionalSkillCandidate.new params[:professional_skill_candidate]
    @professional_skill_candidate.candidate = current_user
    unless @professional_skill_candidate.save
      respond_to { |format| format.html { render :json => @professional_skill_candidate.errors, :status => :unprocessable_entity if request.xhr? } }
    else
      respond_to { |format| format.html { render :json => 'create!' if request.xhr? } }
    end    
  end
  
  def edit
    render :partial => 'edit_form', :locals => { :professional_skill_candidate => ProfessionalSkillCandidate.find(params[:id]) }
  end
  
  def update
    @professional_skill_candidate = ProfessionalSkillCandidate.find params[:id]
    unless @professional_skill_candidate.update_attributes params[:professional_skill_candidate]
      respond_to { |format| format.html { render :json => @professional_skill_candidate.errors, :status => :unprocessable_entity if request.xhr? } }
    else
      respond_to { |format| format.html { render :json => 'update!' if request.xhr? } }
    end  
  end
  
  def destroy
    ProfessionalSkillCandidate.find(params[:id]).destroy
    respond_to { |format| format.html { render :json => 'destroy!' if request.xhr? } }
  end 
end