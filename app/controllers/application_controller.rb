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
  
  def render_page(page, options = {})
    init_page(options) unless options.empty?
    options[:id] ? render(page, :id => options[:id]) : render(page)
  end
  
  def redirect_to_page(page, options = {})
    init_page(options) unless options.empty?
    redirect_to(page)
  end
  
  def init_page(options = {})
    @title            = t(options[:title])          unless options[:title].nil?
    @javascripts      = options[:javascripts].split unless options[:javascripts].nil?
    flash[:success]   = options[:flash][:success]   unless options[:flash].nil? || options[:flash][:success].nil?
    flash[:notice]    = options[:flash][:notice]    unless options[:flash].nil? || options[:flash][:notice].nil?
    flash.now[:error] = options[:flash][:error]     unless options[:flash].nil? || options[:flash][:error].nil?
  end
end