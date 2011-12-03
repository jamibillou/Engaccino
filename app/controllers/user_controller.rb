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
      flash.now[:success] = t('flash.success.welcome') 
      @title = t 'user.new.complete_your_profile'
      render :signup_step_2
    end
  end 
    
  def signup_step_2        
    @user = User.find(@user.id)
    @title = t 'user.new.complete_your_profile'    
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to @user, :flash => { :success => t('flash.success.welcome_home') }
    else
      flash.now[:error] = flash_error_messages(@user)
      render :signup_step_2
    end
  end 

  def edit
    @user = User.find_by_id(params[:id])
    @title = t 'user.edit.title'
  end
<<<<<<< HEAD
<<<<<<< HEAD
   
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
=======
>>>>>>> b232d3a375384cd40141f175723f6093862bde9c
=======
>>>>>>> b232d3a375384cd40141f175723f6093862bde9c

  def destroy
  end

end