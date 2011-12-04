module ApplicationHelper

  def logo
    image_tag "logo.png", :alt => "Engaccino", :id => "logo"
  end
  
  def title 
    base_title = "Engaccino"
    @title.nil? ? base_title : "#{base_title} | #{@title}"
  end
  
  def menu_items
    [{:title => t(:menu_overview),      :path => root_path,        :selected => (t(:menu_overview) == @title)},
     {:title => t(:menu_walkthrough),   :path => walkthrough_path, :selected => (t(:menu_walkthrough) == @title)},
     {:title => t(:menu_pricing),       :path => pricing_path,     :selected => (t(:menu_pricing) == @title)},
     {:title => t(:menu_about),         :path => about_path,       :selected => (t(:menu_about) == @title)},
     {:title => t(:menu_contact),       :path => contact_path,     :selected => (t(:menu_contact) == @title)}]
  end
  
  def trash
    image_tag "trash.png", :alt => t('delete'), :class => "trash"
  end
end