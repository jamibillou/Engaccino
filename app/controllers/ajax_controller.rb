class AjaxController < ApplicationController
  
  def countries
    country_list = search_countries(params[:term]) if (params[:term])
    render json: country_list    
  end
  
  def search_countries(text)
    temp_list = Country.all.select { |item| item[0].downcase.include?(text.downcase) }
    final_list = []
    temp_list.each do |item|
      final_list.push(item[0])
    end
    return final_list.sort
  end

end
