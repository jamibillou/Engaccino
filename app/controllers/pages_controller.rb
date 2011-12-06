class PagesController < ApplicationController
    
  def overview
    @title = t(:menu_overview)
  end

  def tour
    @title = t(:menu_tour)
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