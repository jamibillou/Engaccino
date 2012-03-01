class EducationObserver < ActiveRecord::Observer
  
  def after_create(education)
    set_main(education)
    increase_profile_completion(education)
  end
  
  def after_update(education)
    set_main(education)
  end
  
  def after_destroy(education)
    set_main(education)
    decrease_profile_completion(education)
  end
  
  private
  
    def set_main(education)
      education.candidate.update_attributes :main_education => (education.candidate.last_education.nil? ? nil : education.candidate.last_education.id)
    end
    
    def increase_profile_completion(education)
      education.candidate.update_attributes :profile_completion => education.candidate.profile_completion + (education.description.nil? ? 5 : 10) unless education.candidate.educations.count > 2
    end
    
    def decrease_profile_completion(education)
      education.candidate.update_attributes :profile_completion => education.candidate.profile_completion - (education.description.nil? ? 5 : 10) unless education.candidate.educations.count > 1
    end

end