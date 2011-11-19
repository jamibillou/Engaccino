class PagesController < ApplicationController
    
  def overview
    @title = t(:menu_overview)
  end

  def walkthrough
    @title = t(:menu_walkthrough)
  end

  def pricing
    @title = t(:menu_pricing)
  end

  def about
    @title = t(:menu_about)
  end

  def contact
    @title = t(:menu_contact)
  end
end