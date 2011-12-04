class UserController < ApplicationController
    
  def index
    @users = User.all
    @title = t 'user.index.title'
  end

  def show
    @user = User.find(params[:id])
    @title = "#{@user.first_name} #{@user.last_name}"
  end

  def new
    @user = User.new
    @title = t 'user.new.title'
  end
  
  def create
    @user = User.new(params[:user])
    unless @user.save
      flash.now[:error] = flash_error_messages(@user, [:email, :password])
      render :new
    else
      @title = t 'user.edit.complete_your_profile'
      session[:edit_page] = :signup
      sign_in @user
      render :edit, :id => @user
    end
  end

  def edit
    @user = User.find(params[:id])
    @title = t 'user.edit.title'
  end
  
  def update
    @user = User.find(params[:id])
    if session[:edit_page] == :signup
      edit_title = t 'user.edit.complete_your_profile'
      flash_message = 'welcome'
    else
      session[:edit_page] = :edit
      edit_title = t 'user.edit.title'
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

end