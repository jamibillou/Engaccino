class InterpersonalSkillCandidateObserver < ActiveRecord::Observer
  
  def after_create(interpersonal_skill_candidate)
    update_profile_completion_create(interpersonal_skill_candidate)
  end
  
  def after_destroy(interpersonal_skill_candidate)
    update_profile_completion_destroy(interpersonal_skill_candidate)
  end
  
  private
  
    def update_profile_completion_create(interpersonal_skill_candidate)
      profile_completion = interpersonal_skill_candidate.candidate.profile_completion + 5
      interpersonal_skill_candidate.candidate.update_attributes :profile_completion => profile_completion unless interpersonal_skill_candidate.candidate.interpersonal_skill_candidates.count > 3
    end
  
    def update_profile_completion_destroy(interpersonal_skill_candidate)
      profile_completion = interpersonal_skill_candidate.candidate.profile_completion - 5
      interpersonal_skill_candidate.candidate.update_attributes :profile_completion => profile_completion unless interpersonal_skill_candidate.candidate.interpersonal_skill_candidates.count > 2
    end
end
