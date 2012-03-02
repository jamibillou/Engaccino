class LanguageCandidateObserver < ActiveRecord::Observer
  
  def after_create(language_candidate)
    update_profile_completion_create(language_candidate)
  end
  
  def after_destroy(language_candidate)
    update_profile_completion_destroy(language_candidate)
  end
  
  private
    
    def update_profile_completion_create(language_candidate)
      language_candidate.candidate.update_attributes :profile_completion => language_candidate.candidate.profile_completion + 5 unless language_candidate.candidate.language_candidates.count > 1
    end
    
    def update_profile_completion_destroy(language_candidate)
      language_candidate.candidate.update_attributes :profile_completion => language_candidate.candidate.profile_completion - 5 unless language_candidate.candidate.language_candidates.count > 0
    end
end
