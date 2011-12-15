class CandidatesController < ApplicationController
  
  def new
    @candidates = Candidate.all
    @title = t 'candidates.index.title'
    @javascripts = ['users/index']
  end
  
  def show
    @candidate = Candidate.find(params[:id])
    @title = "#{@candidate.first_name} #{@candidate.last_name}"
  end
  
  def create
    
  end

end
