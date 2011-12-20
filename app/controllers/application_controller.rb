class ApplicationController < ActionController::Base
  
  include SessionsHelper
  
  protect_from_forgery
  
  before_filter :set_locale
  
  def set_locale
    I18n.default_locale = params[:locale] if !params[:locale].nil?
    I18n.locale = I18n.default_locale
  end
  
  def error_messages(object, only_for_attributes = false)
    errors = unduplicated_errors(object, only_for_attributes)
    errors.map! do |error|
      "#{object.class.human_attribute_name(error[0]).downcase} #{error[1]}#{(error != errors.last) ? ", " : "."}"
    end.insert(0, "#{t('flash.error.base')}#{t('_:')} ").join
  end
  
  def unduplicated_errors(object, only_for_attributes = false)
    object.errors.select do |attribute, message|
      if only_for_attributes
        only_for_attributes.include?(attribute) && message == object.errors[attribute].first
      else
        message == object.errors[attribute].first
      end
    end
  end
  
  def render_page(page, title, javascripts, options = {})
    set_title_javascripts(title, javascripts, options)
    options[:id] ? render(page, :id => options[:id]) : render(page)
  end
  
  def set_title_javascripts(title, javascripts, options = {})
    @title = title
    @javascripts = javascripts
    flash.now[options[:flash][:type]] = options[:flash][:message] if options[:flash]
  end
  
end