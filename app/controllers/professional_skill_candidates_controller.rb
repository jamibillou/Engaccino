class ProfessionalSkillCandidatesController < ApplicationController
  
  def new
    @professional_skill_candidate = ProfessionalSkillCandidate.new
    @professional_skill_candidate.build_professional_skill
    render :partial => 'new_form'
  end
  
  def edit
    render :partial => 'edit_form', :locals => { :professional_skill_candidate => ProfessionalSkillCandidate.find(:id) }
  end
  
end
