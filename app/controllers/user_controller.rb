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
  end

  def update
  end

  def destroy
  end

end