class InterpersonalSkillCandidatesController < ApplicationController
  
  def new
    @interpersonal_skill_candidate = InterpersonalSkillCandidate.new
    @interpersonal_skill_candidate.build_interpersonal_skill
    render :partial => 'new_form'
  end
  
  def edit
    render :partial => 'edit_form', :locals => { :interpersonal_skill_candidate => InterpersonalSkillCandidate.find(:id) }
  end
  
end
