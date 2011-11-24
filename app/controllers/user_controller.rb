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
    if @user.save
      # sign_in @user
      redirect_to @user, :flash => { :success => "Welcome to Engaccino!" }
    else
      @title = t 'user.new.title'
      flash.now[:error] = "Something went wrong, sorry about that."
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
