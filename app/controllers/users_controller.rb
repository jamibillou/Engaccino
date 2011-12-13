class UsersController < ApplicationController
    
  before_filter :authenticate, :except => [:new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :completed_signup, :only => [:index, :show]
  before_filter :admin_user, :only => [:destroy]
  before_filter :new_user, :only => [:new, :create]
  
  def index
    @users = User.all
    @title = t 'users.index.title'
    @javascripts = ['users/index']
  end

  def show
    @user = User.find(params[:id])
    @title = "#{@user.first_name} #{@user.last_name}"
  end

  def new
    @user = User.new
    @title = t 'users.new.title'
    @javascripts = ['users/new']
  end
  
  def create
    @user = User.new(params[:user])
    unless @user.save
      flash.now[:error] = flash_error_messages(@user, [:email, :password])
      @javascripts = ['users/new']
      render :new
    else
      @title = t 'users.edit.complete_your_profile'
      sign_in @user
      @javascripts = ['users/edit']
      render :edit, :id => @user
    end
  end

  def edit
    @title = completed_signup? ? t('users.edit.title') : t('users.edit.complete_your_profile')
    @javascripts = ['users/edit']
  end
  
  def update
    if @user.update_attributes(params[:user])
      @title = "#{@user.first_name} #{@user.last_name}"
      flash_message = completed_signup? ? 'profile_updated' : 'welcome'
      @user.update_attributes(:profile_completion => 10) unless completed_signup?
      redirect_to @user, :flash => { :success => t("flash.success.#{flash_message}") }
    else
      flash.now[:error] = flash_error_messages(@user)
      @javascripts = ['users/edit']
      @title = completed_signup? ? t('users.edit.title') : t('users.edit.complete_your_profile')
      @javascripts = ['users/edit']
      render :edit, :id => @user
    end
  end 

  def destroy
   User.find(params[:id]).destroy
   redirect_to users_path, :flash => { :success => t('flash.success.user_destroyed') }
  end
  
  private
  
    def authenticate
      deny_access unless signed_in?
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to user_path(current_user), :notice => t('flash.notice.other_user_page') unless current_user?(@user)
    end
    
    def completed_signup
      @user = current_user
      redirect_to edit_user_path(@user), :notice => t('flash.notice.please_finish_signup') unless completed_signup?
    end
    
    def admin_user
      @user = current_user
      redirect_to user_path(@user), :notice => t('flash.notice.restricted_page') unless @user.admin
    end
    
    def new_user
      unless current_user.nil?
        @user = current_user
        redirect_to user_path(@user), :notice => t('flash.notice.already_registered')
      end
    end
end