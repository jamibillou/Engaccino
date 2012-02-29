class AjaxController < ApplicationController
  
  def countries
    render json: Country.all.map { |country| country[0] }.select { |country| country.downcase.include? params[:term].downcase }.sort
  end
  
  def months
    render json: [ t('months.january'), t('months.february'), t('months.march'), t('months.april'), t('months.may'), t('months.june'), t('months.july'),
                   t('months.august'), t('months.september'), t('months.october'), t('months.november'), t('months.december') ].select { |month| month.downcase.start_with? params[:term].downcase }
  end
  
  def years
    render json: (100.years.ago.year..Time.now.year).to_a.map { |year| year.to_s }.select { |year| year.downcase.start_with? params[:term].downcase }.reverse
  end
  
end
