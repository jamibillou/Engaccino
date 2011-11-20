module ApplicationHelper

  def logo
    image_tag("logo.png", :alt => "Engaccino", :id => "logo")
  end
  
  def title 
    base_title = "Engaccino"
    if @title.nil?
      base_title
    else 
      "#{base_title} | #{@title}"
    end
  end
  
  def menu_items
    [{:title => t(:menu_overview),      :path => root_path,        :selected => (t(:menu_overview) == @title)},
     {:title => t(:menu_walkthrough),   :path => walkthrough_path, :selected => (t(:menu_walkthrough) == @title)},
     {:title => t(:menu_pricing),       :path => pricing_path,     :selected => (t(:menu_pricing) == @title)},
     {:title => t(:menu_about),         :path => about_path,       :selected => (t(:menu_about) == @title)},
     {:title => t(:menu_contact),       :path => contact_path,     :selected => (t(:menu_contact) == @title)}]
  end
  
end