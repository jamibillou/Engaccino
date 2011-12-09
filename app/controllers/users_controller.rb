class UsersController < ApplicationController
    
  before_filter :authenticate, :except => [:new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  
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
      session[:edit_page] = :signup
      sign_in @user
      @javascripts = ['users/edit']
      render :edit, :id => @user
    end
  end

  def edit
    @title = t 'users.edit.title'
    @javascripts = ['users/edit']
  end
  
  def update
    if session[:edit_page] == :signup
      edit_title = t 'users.edit.complete_your_profile'
      flash_message = 'welcome'
    else
      session[:edit_page] = :edit
      edit_title = t 'users.edit.title'
      flash_message = 'profile_updated'
    end
    if @user.update_attributes(params[:user])
      session[:edit_page] = :edit
      @title = "#{@user.first_name} #{@user.last_name}"
      redirect_to @user, :flash => { :success => t("flash.success.#{flash_message}") }
    else
      flash.now[:error] = flash_error_messages(@user)
      @title = edit_title
      render :edit
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
end