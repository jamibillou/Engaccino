class UserController < ApplicationController
    
  def index
  end

  def show
    @user = User.find(params[:id])
    @title = "#{@user.first_name} #{@user.last_name}"
  end

  def new
    @user = User.new
    @title = t 'user.new.title'
  end 
    
  def signup_step_2
    @user = User.new(params[:user])
    unless @user.valid_attribute?(:email) && @user.valid_attribute?(:password)
      flash.now[:error] = flash_error_messages(@user, [:email, :password])
      render :new
    else
      @title = t 'user.new.complete_your_profile'
    end
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to @user, :flash => { :success => t('flash.success.welcome') }
    else
      @title = t 'user.new.complete_your_profile'
      flash.now[:error] = flash_error_messages(@user)
      render :signup_step_2
    end
  end 

  def edit
    @user = User.find_by_id(params[:id])
    @title = t 'user.edit.title'
  end
   
  def update
    @user = User.find_by_id(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to @user, :flash => { :success => t('flash.success.profile_updated') }
    else
      @title = t 'user.edit.title'
      flash.now[:error] = flash_error_messages(@user)
      render :edit
    end
  end

  def destroy
  end

end