class SessionsController < ApplicationController
  
  def new
   set_title_javascripts(I18n.t('sessions.new.title'), ['sessions/sessions'])
  end
  
  def create
    user = User.authenticate(params[:session][:email], params[:session][:password])
    if user.nil?
      render_page(:new, I18n.t('sessions.new.title'), ['sessions/sessions'], :flash => { :message => I18n.t('flash.error.signin'), :type => :error })
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