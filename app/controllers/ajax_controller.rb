class AjaxController < ApplicationController
  
  def countries
    countries = find_countries(params[:term]) if (params[:term])
    render json: countries    
  end
  
  def find_countries(text)
    Country.all.select { |item| item[0].downcase.include?(text.downcase) }.map { |item| item[0] }.sort
  end
end
