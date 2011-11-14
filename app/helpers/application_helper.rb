module ApplicationHelper

  def title 
    base_title = "Engaccino"
    if @title.nil?
      base_title
    else 
      "#{base_title} | #{@title}"
    end
  end
  
  def logo
    image_tag("logo.png", :alt => "Engaccino", :class => "logo")
  end
end