module ApplicationHelper

  def logo
    image_tag "logo.png", :alt => "Engaccino", :id => "logo"
  end
  
  def title 
    base_title = "Engaccino"
    @title.nil? ? base_title : "#{base_title} | #{@title}"
  end
  
  def settings
    image_tag "settings.png", :alt => t('settings'), :class => "settings"
  end
  
  def trash
    image_tag "trash.png", :alt => t('delete'), :class => "trash"
  end
  
end