class SessionsController < ApplicationController
  
  def new
    @title = I18n.t('sessions.new.title')
    @javascripts = ['sessions/sessions']
  end
  
  def create
    user = User.authenticate(params[:session][:email], params[:session][:password])
    if user.nil?
      flash.now[:error] = I18n.t('flash.error.signin')
      @title = I18n.t('sessions.new.title')
      @javascripts = ['sessions/sessions']
      render :new  
    else
      sign_in(user, params[:session][:remember_me])
      redirect_back_or(user)
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
end