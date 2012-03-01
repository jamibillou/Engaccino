class EducationObserver < ActiveRecord::Observer
  
  def after_update(education)
    set_main(education)
  end
  
  def after_create(education)
    set_main(education)
  end
  
  def after_destroy(education)
    set_main(education)
  end
  
  private
  
    def set_main(education)
      education.candidate.update_attributes :main_education => (education.candidate.last_education.nil? ? nil : education.candidate.last_education.id)
    end
  # 
  #   def update_completion_new
  #     candidate.update_attributes :profile_completion => candidate.profile_completion + 5 if candidate.educations.count < 4
  #   end
  # 
  #   def update_completion_del
  #     candidate.update_attributes :profile_completion => candidate.profile_completion - 5 if candidate.educations.count < 3
  #   end
end
