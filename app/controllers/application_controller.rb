class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_locale
  
  # Avoids having to pass the locale as a parameter in the URL
  def set_locale
    I18n.default_locale = params[:locale] if !params[:locale].nil?
    I18n.locale = I18n.default_locale
  end
  
  def flash_error_messages(object, only_for_attributes = false)
    flash_error = "#{t('flash.error.base')}#{t('_:')} "
    errors = full_messages_errors_no_duplicates(object, only_for_attributes)
    
    errors.each_with_index do |error, index|
      flash_error += "#{object.class.human_attribute_name(error[0]).downcase} #{error[1]}"
      if index != errors.count-1
        flash_error += ", "
      else
        flash_error += "."
      end
    end
    
    flash_error
  end
  
  def full_messages_errors_no_duplicates(object, only_for_attributes = false)
    object.errors.select do |attribute, message|
      if only_for_attributes
        only_for_attributes.include?(attribute) && message == object.errors[attribute].first
      else
        message == object.errors[attribute].first
      end
    end
  end
  
end
