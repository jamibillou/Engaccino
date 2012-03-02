class UserObserver < ActiveRecord::Observer
  
  def after_update(user)
    set_profile_completion_update(user)
  end
  
  private
   
    def set_profile_completion_update(user)
      user.update_attributes :profile_completion => 5 if user.profile_completion == 0 && added_first_name?(user) && added_last_name?(user) && added_city?(user) && added_country?(user)
    end
    
    def added_first_name?(user)
      user.first_name_changed? && user.first_name_was == I18n.t('users.first_name') && !user.first_name.blank?
    end
    
    def added_last_name?(user)
      user.last_name_changed? && user.last_name_was == I18n.t('users.last_name') && !user.last_name.blank?
    end
    
    def added_city?(user)
      user.city_changed? && user.city_was == I18n.t('users.city') && !user.city.blank?
    end
    
    def added_country?(user)
      user.country_changed? && user.country_was == 'France' && !user.country.blank?
    end
    
end
