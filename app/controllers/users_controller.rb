class UsersController < ApplicationController
    
  before_filter :authenticate
  before_filter :completed_signup,  :only => [:index]
  before_filter :admin_user,        :only => [:destroy]
  
  def index
    @users = User.all
    set_title_javascripts(t('users.index.title'), ['users/index'])
  end

  def destroy
   User.find(params[:id]).destroy
   redirect_to users_path, :flash => { :success => t('flash.success.user_destroyed') }
  end
  
  private
  
    def authenticate
      deny_access unless signed_in?
    end
  
    def completed_signup
      @user = current_user
      redirect_to edit_candidate_path(@user), :notice => t('flash.notice.please_finish_signup') unless completed_signup?
    end
    
    def admin_user
      @user = current_user
      redirect_to candidate_path(@user), :notice => t('flash.notice.restricted_page') unless @user.admin
    end
end