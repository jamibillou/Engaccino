class ProfessionalSkillCandidateObserver < ActiveRecord::Observer
  
  def after_create(professional_skill_candidate)
    update_profile_completion_create(professional_skill_candidate)
  end
  
  def after_update(professional_skill_candidate)
    update_profile_completion_update(professional_skill_candidate)
  end
  
  def after_destroy(professional_skill_candidate)
    update_profile_completion_destroy(professional_skill_candidate)
  end
  
  private
  
    def update_profile_completion_create(professional_skill_candidate)
      profile_completion = professional_skill_candidate.candidate.profile_completion + (professional_skill_candidate.description.nil? || professional_skill_candidate.description == '' ? 5 : 10)
      professional_skill_candidate.candidate.update_attributes :profile_completion => profile_completion unless professional_skill_candidate.candidate.professional_skill_candidates.count > 2
    end
  
    def update_profile_completion_destroy(professional_skill_candidate)
      profile_completion = professional_skill_candidate.candidate.profile_completion - (professional_skill_candidate.description.nil? || professional_skill_candidate.description == '' ? 5 : 10)
      professional_skill_candidate.candidate.update_attributes :profile_completion => profile_completion unless professional_skill_candidate.candidate.professional_skill_candidates.count > 1
    end
  
    def update_profile_completion_update(professional_skill_candidate)
      if professional_skill_candidate.description_changed?
        val = (professional_skill_candidate.description_was == nil || professional_skill_candidate.description_was == '') ? 5 : (professional_skill_candidate.description == '' ? -5 : nil)
        professional_skill_candidate.candidate.update_attributes :profile_completion => professional_skill_candidate.candidate.profile_completion + val unless val.nil?
      end
    end
end
