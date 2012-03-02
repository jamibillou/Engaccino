class EducationObserver < ActiveRecord::Observer
  
  def after_create(education)
    set_main(education)
    update_profile_completion_create(education)
  end
  
  def after_update(education)
    set_main(education)
    update_profile_completion_update(education)
  end
  
  def after_destroy(education)
    set_main(education)
    update_profile_completion_destroy(education)
  end
  
  private
  
    def set_main(education)
      education.candidate.update_attributes :main_education => (education.candidate.last_education.nil? ? nil : education.candidate.last_education.id)
    end
    
    def update_profile_completion_create(education)
      education.candidate.update_attributes :profile_completion => education.candidate.profile_completion + (education.description.nil? ? 5 : 10) unless education.candidate.educations.count > 2
    end
    
    def update_profile_completion_destroy(education)
      education.candidate.update_attributes :profile_completion => education.candidate.profile_completion - (education.description.nil? ? 5 : 10) unless education.candidate.educations.count > 1
    end
    
    def update_profile_completion_update(education)
      if education.description_changed?
        val = (education.description_was == nil || education.description_was == '') ? 5 : (education.description == '' ? -5 : nil)
        education.candidate.update_attributes :profile_completion => education.candidate.profile_completion + val unless val.nil?
      end
    end
end