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
    if (!(params[:email] =~ /^[\w+\d\-.]+@[a-z\d\-.]+\.[a-z.]+$/i)) || (params[:password].length < 6 || params[:password].length > 40 ) ||  (params[:password] != params[:password_confirmation])
      flash.now[:error] = t 'flash.error'
      render :new
    else
      session[:new_user] = params
      @title = t 'user.new.complete_your_profile'
    end
  end
  
  def create
    @user = User.new(params[:user].merge(:email => session[:new_user][:email], :password => session[:new_user][:password]))
    if @user.save
      # sign_in @user
      redirect_to @user, :flash => { :success => "Welcome to Engaccino!" }
    else
      @title = t 'user.new.complete_your_profile'
      flash.now[:error] = t 'flash.error'
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