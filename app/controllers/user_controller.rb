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
    @user = User.new
    @new_user = User.new(params)
    session[:new_user] = params
    unless @new_user.valid_attribute?(:email) && @new_user.valid_attribute?(:password)
      flash.now[:error] = flash_error_messages(@new_user, [:email, :password])
      render :new
    else
      @title = t 'user.new.complete_your_profile'
    end
  end
  
  def create
    @user = User.new(params[:user].merge(:email => session[:new_user][:email], :password => session[:new_user][:password]))
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