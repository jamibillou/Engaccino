class RelationshipsController < ApplicationController
  
  before_filter :authenticate, :ajax_only
  
  def create
    current_user.follow! User.find params[:user_id]
    render :partial => 'shared/unfollow', :locals => { :user_id => params[:user_id] }
  end
  
  def destroy
    current_user.unfollow! User.find params[:user_id]
    render :partial => 'shared/follow', :locals => { :user_id => params[:user_id] }
  end
end