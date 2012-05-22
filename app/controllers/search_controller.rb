class SearchController < ApplicationController
  
  before_filter :authenticate
  
  def index
    @search = params[:search]
    @candidates = search_candidates
    @recruiters = search_recruiters
    @companies = search_companies
    init_page :javascripts => 'search'
  end
  
  private
    def search_candidates
      if current_user.type == "Recruiter" || current_user.admin?
        Candidate.where("first_name LIKE '%#{@search}%' OR last_name LIKE '%#{@search}%'").order(:last_name)
      else
        []
      end
    end
    
    def search_recruiters
      if current_user.type == "Candidate" || current_user.admin?
        Recruiter.where("first_name LIKE '%#{@search}%' OR last_name LIKE '%#{@search}%'").order(:last_name)
      else
        []
      end
    end
    
    def search_companies
      if current_user.type == "Candidate" || current_user.admin?
        Company.where("name LIKE '%#{@search}%'").order(:name)
      else
        []
      end
    end
end
