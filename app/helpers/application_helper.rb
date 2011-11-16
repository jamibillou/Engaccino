module ApplicationHelper

  def logo
    image_tag("logo.png", :alt => "Engaccino", :class => "logo")
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
    [{:title => "Overview",      :path => root_path,        :selected => ("Overview" == @title)},
     {:title => "Walkthrough",   :path => walkthrough_path, :selected => ("Walkthrough" == @title)},
     {:title => "Pricing",       :path => pricing_path,     :selected => ("Pricing" == @title)},
     {:title => "About",         :path => about_path,       :selected => ("About" == @title)},
     {:title => "Contact",       :path => contact_path,     :selected => ("Contact" == @title)}]
  end
  
end