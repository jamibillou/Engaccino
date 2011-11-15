class PagesController < ApplicationController
  
  before_filter :initMenu
  
  def overview
    @title = "Overview"
  end

  def walkthrough
    @title = "Walkthrough"
  end

  def pricing
    @title = "Pricing"
  end

  def about
    @title = "About"
  end

  def contact
    @title = "Contact"
  end
  
  def initMenu
    @menuItems = [{"title" => "Overview",    "link" => root_path},
                  {"title" => "Walkthrough",   "link" => walkthrough_path},
                  {"title" => "Pricing",       "link" => pricing_path},
                  {"title" => "About",         "link" => about_path},
                  {"title" => "Contact",       "link" => contact_path}]
  end
end