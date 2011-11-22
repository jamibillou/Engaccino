class UserController < ApplicationController
  
  def index
  end

  def show
  end

  def new
    @user = User.new
    @title = t 'user.new.title'
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
