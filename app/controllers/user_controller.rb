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
    if !@user.valid_attribute?(:email) || !@user.valid_attribute?(:password)
      flash.now[:error] = t 'flash.error'
      render :new
    else
      session[:new_user] = @user
      render :create
    end
  end  
    
  def create2
    @user = session[:new_user]
    @user.update_attributes(params[:user])
    if @user.save
      # sign_in @user
      redirect_to @user, :flash => { :success => "Welcome to Engaccino!" }  
    else
      @title = t 'user.new.title'
      flash.now[:error] = t 'flash.error'
      render :create
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
