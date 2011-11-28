class AjaxController < ApplicationController
  
  def countries
    country_list = search_countries(params[:term]) if(params[:term])
    render json: country_list    
  end
  
  def search_countries(text)
    temp_list = Country.all.select{|item| item[0].downcase.include?(text.downcase)}
    #We only need the first element of the array (the complete country name)
    final_list = Array.new
    temp_list.each do |item|
      final_list.push(item[0])
    end
    return final_list.sort
  end
  
  def code
    country_code = search_code(params[:country])
    respond_to do |format|
      format.json { render :json => {:code => country_code}}
    end
  end
  
  def search_code(country)
    full_country = Country.find_by_name(country)
    return full_country[0]
  end

end
