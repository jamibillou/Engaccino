class PagesController < ApplicationController
  
  before_filter :init_menu
  
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
  
  #Each menu item is a element of the array
  def init_menu
    @menu_items = [{:title => "Overview",     :link => root_path},
                  {:title => "Walkthrough",   :link => walkthrough_path},
                  {:title => "Pricing",       :link => pricing_path},
                  {:title => "About",         :link => about_path},
                  {:title => "Contact",       :link => contact_path}]
  end
end