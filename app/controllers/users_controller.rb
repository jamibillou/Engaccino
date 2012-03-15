class UsersController < ApplicationController

  def index
    root_path = case current_user.class.name.downcase
      when 'candidate'
        recruiters_path
      when 'recruiter'
        candidates_path
    end
    redirect_to root_path     
  end
end