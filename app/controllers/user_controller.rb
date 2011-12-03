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
  
  def create
    @user = User.new(params[:user])
    unless @user.save
      flash.now[:error] = flash_error_messages(@user, [:email, :password])
      render :new
    else
      @title = t 'user.new.complete_your_profile'
      render :signup_step_2, :id => @user
    end
  end 

  def signup_step_2
    @user = User.find(params[:id])
    @title = t 'user.new.complete_your_profile'
  end

  def edit
    @user = User.find(params[:id])
    @title = t 'user.edit.title'
  end
  
  def update
    if params[:id] == 'update'
      origin_page = :signup_step_2
      origin_page_title = t 'user.new.complete_your_profile'
      @user = User.find(params[:user][:id])
      flash_message = 'flash.success.welcome'
    else
      origin_page = :edit
      origin_page_title = t 'user.edit.title'
      @user = User.find(params[:id])
      flash_message = 'flash.success.profile_updated'
    end
    if @user.update_attributes(params[:user])
      @title = "#{@user.first_name} #{@user.last_name}"
      redirect_to @user, :flash => { :success => t(flash_message) }
    else
      flash.now[:error] = flash_error_messages(@user)
      @title = origin_page_title
      render origin_page
    end
  end 

  def destroy
  end

end