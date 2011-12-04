class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_locale
  include SessionsHelper
  
  def set_locale
    I18n.default_locale = params[:locale] if !params[:locale].nil?
    I18n.locale = I18n.default_locale
  end
  
  def flash_error_messages(object, only_for_attributes = false)
    errors = errors_without_duplicates(object, only_for_attributes)
    errors.map! do |error|
      "#{object.class.human_attribute_name(error[0]).downcase} #{error[1]}#{(error != errors.last) ? ", " : "."}"
    end.insert(0, "#{t('flash.error.base')}#{t('_:')} ").join
  end
  
  def errors_without_duplicates(object, only_for_attributes = false)
    object.errors.select do |attribute, message|
      if only_for_attributes
        only_for_attributes.include?(attribute) && message == object.errors[attribute].first
      else
        message == object.errors[attribute].first
      end
    end
  end
  
end