class UserController < ApplicationController
    
  def index
  end

  def show
  end

  def new
    @title = t 'user.new.title'
    @user = User.new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
