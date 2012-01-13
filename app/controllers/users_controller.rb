class UsersController < ApplicationController
    
  include UsersHelper
  
  before_filter :authenticate
  before_filter :signed_up,   :only => [:index]
  before_filter :admin_user,  :only => [:destroy]
  
  def index
    @users = User.all
    init_page :title => 'users.index.title', :javascripts => 'users/index'
  end

  def destroy
   User.find(params[:id]).destroy
   redirect_to users_path, :flash => { :success => t('flash.success.user_destroyed') }
  end
  
  private
  
    def authenticate
      deny_access unless signed_in?
    end
  
    def signed_up
      @user = current_user
      redirect_to edit_candidate_path(@user), :notice => t('flash.notice.please_finish_signup') unless signed_up?
    end
    
    def admin_user
      @user = current_user
      redirect_to candidate_path(@user), :notice => t('flash.notice.restricted_page') unless @user.admin
    end
    
end