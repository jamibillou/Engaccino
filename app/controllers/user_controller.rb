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
    if !params[:step].nil?
      @title = t 'user.new.title'
      check_first_step
      render :new
    elsif @user.save
      # sign_in @user
      redirect_to @user, :flash => { :success => "Welcome to Engaccino!" }  
    else
      @title = t 'user.new.title'
      flash.now[:error] = t 'flash.error'
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end
  
  private
    def check_first_step
      if !@user.valid_attribute?(:email) || !@user.valid_attribute?(:password)
        params[:step] = nil
        flash.now[:error] = t 'flash.error'
      else
        
      end
    end

end
