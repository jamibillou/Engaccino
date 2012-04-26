class UsersController < ApplicationController

  def index
    root_path = current_user.candidate? ? recruiters_path : candidates_path
    redirect_to root_path     
  end
end