class ApplicationController < ActionController::Base
  
  include SessionsHelper
  
  protect_from_forgery
  
  before_filter :set_locale
  
  def set_locale
    I18n.default_locale = params[:locale] if !params[:locale].nil?
    I18n.locale = I18n.default_locale
  end
  
  def error_messages(object, options = {})
    errors = unduplicated_errors(object, options).map! do |attribute, message|
      "#{object.class.human_attribute_name(attribute).downcase} #{message}"
    end.to_sentence
    "#{t('flash.error.base')} #{errors}."
  end
  
  def unduplicated_errors(object, options = {})
    object.errors.select do |attribute, message|
      options[:only] ? options[:only].include?(attribute) && message == object.errors[attribute].first : message == object.errors[attribute].first
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