class PagesController < ApplicationController
  
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
end