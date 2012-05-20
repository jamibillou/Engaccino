class AjaxController < ApplicationController
  
  def countries
    render json: Country.all.map { |country| country[0] }.select { |country| country.downcase.include? params[:term].downcase }.sort
  end
  
  def months
    render json: [ { label:t('months.january'), index:1 }, { label:t('months.february'), index:2 }, { label:t('months.march'), index:3 }, 
                   { label:t('months.april'), index:4 }, { label:t('months.may'), index:5 }, { label:t('months.june'), index:6 }, 
                   { label:t('months.july'), index:7 }, { label:t('months.august'), index:8 }, { label:t('months.september'), index:9 }, 
                   { label:t('months.october'), index:10 }, { label:t('months.november'), index:11 }, { label:t('months.december'), index:12 } ].select { |month| month[:label].downcase.start_with? params[:term].downcase }
  end
  
  def companies
    hash_companies = []
    Company.all.each do |company|
      hash_companies << {"id" => company.id, "value" => "#{company.name}", "label" => "#{company.name}  (#{company.city}, #{company.country})", "url" => company.url, "city" => company.city, "country" => company.country} if company.name.downcase.include? params[:term].downcase
    end
    render json: hash_companies
  end
  
  def recipients
    hash_recipients = []
    if current_user.type == "Recruiter"
      Candidate.all(:order => :last_name).each do |candidate|
        hash_recipients << {"id" => candidate.id, "value" => "#{candidate.first_name} #{candidate.last_name}", "label" => "#{candidate.first_name} #{candidate.last_name} (#{candidate.city}, #{candidate.country})"} if candidate.first_name.downcase.include?(params[:term].downcase) || candidate.last_name.downcase.include?(params[:term].downcase)
      end
    else
      Recruiter.all(:order => :last_name).each do |recruiter|
        hash_recipients << {"id" => recruiter.id, "value" => "#{recruiter.first_name} #{recruiter.last_name}", "label" => "#{recruiter.first_name} #{recruiter.last_name} (#{recruiter.city}, #{recruiter.country})"} if recruiter.first_name.downcase.include?(params[:term].downcase) || recruiter.last_name.downcase.include?(params[:term].downcase)
      end
    end
    render json: hash_recipients 
  end  
  
  def search
    hash_results = []
    if current_user.type == "Recruiter"
      Candidate.all(:order => :last_name).each do |candidate|
        hash_results << {"type" => "candidates", "id" => candidate.id, "value" => "#{candidate.first_name} #{candidate.last_name}", "label" => "#{candidate.first_name} #{candidate.last_name} (#{candidate.city}, #{candidate.country})"} if candidate.first_name.downcase.include?(params[:term].downcase) || candidate.last_name.downcase.include?(params[:term].downcase)
      end
    else
      Recruiter.all(:order => :last_name).each do |recruiter|
        hash_results << {"type" => "recruiters", "id" => recruiter.id, "value" => "#{recruiter.first_name} #{recruiter.last_name}", "label" => "#{recruiter.first_name} #{recruiter.last_name} (#{recruiter.city}, #{recruiter.country})"} if recruiter.first_name.downcase.include?(params[:term].downcase) || recruiter.last_name.downcase.include?(params[:term].downcase)
      end
      Company.all(:order => :name).each do |company|
        hash_results << {"type" => "companies", "id" => company.id, "value" => "#{company.name}", "label" => "#{company.name} (#{company.city} #{company.country})"} if company.name.downcase.include?(params[:term].downcase)
      end
    end
    render json: hash_results
  end
end
