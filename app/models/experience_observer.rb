class ExperienceObserver < ActiveRecord::Observer
  
  def after_create(experience)
    set_main(experience)
    set_current_date(experience)
  end
  
  def after_update(experience)
    set_main(experience)
    set_current_date(experience)
  end
  
  def after_destroy(experience)
    set_main(experience)
  end
  
  private
  
    def set_main(experience)
      experience.candidate.update_attributes :main_experience => (experience.candidate.last_experience.nil? ? nil : experience.candidate.last_experience.id)
    end
    
    def set_current_date(experience)
      (experience.end_month = Time.now.month ; experience.end_year = Time.now.year) if experience.current?
    end
    
    # def update_completion_new
    #   candidate.update_attributes :profile_completion => candidate.profile_completion + 5 if candidate.experiences.count < 4
    # end
    #   
    # def update_completion_del
    #   candidate.update_attributes :profile_completion => candidate.profile_completion - 5 if candidate.experiences.count < 3
    # end
end
