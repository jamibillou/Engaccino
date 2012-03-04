class ProfessionalSkillCandidateObserver < ActiveRecord::Observer
  
  def after_create(professional_skill_candidate)
    update_profile_completion_create(professional_skill_candidate)
  end
  
  def after_destroy(professional_skill_candidate)
    update_profile_completion_destroy(professional_skill_candidate)
  end
  
  private
  
    def update_profile_completion_create(professional_skill_candidate)
      professional_skill_candidate.candidate.update_attributes :profile_completion => professional_skill_candidate.candidate.profile_completion + 10 unless professional_skill_candidate.candidate.professional_skill_candidates.count > 2
    end
  
    def update_profile_completion_destroy(professional_skill_candidate)
      professional_skill_candidate.candidate.update_attributes :profile_completion => professional_skill_candidate.candidate.profile_completion - 10 unless professional_skill_candidate.candidate.professional_skill_candidates.count > 1
    end
end
