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
    # @new_user = User.new(params) # could not get the valid_attribute? method to work
    # unless @new_user.valid_attribute?(:email) && @new_user.valid_attribute?(:password))
    unless ((params[:email] =~ /^[\w+\d\-.]+@[a-z\d\-.]+\.[a-z.]+$/i) && (params[:password].length >= 6 && params[:password].length <= 40 ) && (params[:password] == params[:password_confirmation]))
      flash.now[:error] = t 'flash.error.general'
      render :new
    else
      session[:new_user] = params
      @title = t 'user.new.complete_your_profile'
    end
  end
  
  def create
    @user = User.new(params[:user].merge(:email => session[:new_user][:email], :password => session[:new_user][:password]))
    if @user.save
      redirect_to @user, :flash => { :success => t('flash.success.welcome') }
    else
      @title = t 'user.new.complete_your_profile'
      flash.now[:error] = t 'flash.error.general'
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