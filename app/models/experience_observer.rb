class ExperienceObserver < ActiveRecord::Observer
  
  def after_create(experience)
    set_main(experience)
    set_current_date(experience)
    update_profile_completion_create(experience)
  end
  
  def after_update(experience)
    set_main(experience)
    set_current_date(experience)
    update_profile_completion_update(experience)
  end
  
  def after_destroy(experience)
    set_main(experience)
    update_profile_completion_destroy(experience)
  end
  
  private
  
    def set_main(experience)
      experience.candidate.update_attributes :main_experience => (experience.candidate.last_experience.nil? ? nil : experience.candidate.last_experience.id)
    end
    
    def set_current_date(experience)
      (experience.end_month = Time.now.month ; experience.end_year = Time.now.year) if experience.current?
    end
    
    def update_profile_completion_create(experience)
      experience.candidate.update_attributes :profile_completion => experience.candidate.profile_completion + (experience.description.nil? ? 5 : 10) unless experience.candidate.experiences.count > 3
    end
    
    def update_profile_completion_destroy(experience)
      experience.candidate.update_attributes :profile_completion => experience.candidate.profile_completion - (experience.description.nil? ? 5 : 10) unless experience.candidate.experiences.count > 2
    end
    
    def update_profile_completion_update(experience)
      if experience.description_changed?
        val = (experience.description_was == nil || experience.description_was == '') ? 5 : (experience.description == '' ? -5 : nil)
        experience.candidate.update_attributes :profile_completion => experience.candidate.profile_completion + val unless val.nil?
      end
    end
end
