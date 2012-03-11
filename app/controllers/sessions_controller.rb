class SessionsController < ApplicationController
  
  def new
   init_page :title => 'sessions.new.title'
  end
  
  def create
    user = User.authenticate params[:session][:email], params[:session][:password]
    if user.nil?
      render_page :new, :title => 'sessions.new.title', :flash => { :error => t('flash.error.signin') }
    else
      sign_in user, params[:session][:remember_me] ; redirect_back_or user
    end
  end
  
  def destroy
    sign_out ; redirect_to root_path
  end
end