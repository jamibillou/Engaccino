class AjaxController < ApplicationController
  
  def countries
    countries = find_countries(params[:term]) if (params[:term])
    render json: countries    
  end
  
  def find_countries(text)
    Country.all.select { |item| item[0].downcase.include?(text.downcase) }.map { |item| item[0] }.sort
  end
  
  def code
    respond_to do |format|
      format.json { render :json => { :code => find_code(params[:country]) } }
    end
  end
  
  def find_code(country)
    return Country.find_by_name(country)[0] unless Country.find_by_name(country).nil?
    return "error" 
  end

end
