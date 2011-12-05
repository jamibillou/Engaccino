require 'spec_helper'

describe "FriendlyForwardings" do

  before(:each) do
    @user = Factory(:user)
  end
  
  describe "should forward to the requested page after signin" do
  
    it "profile" do
      visit user_path(@user)
      fill_in :email,    :with => @user.email
      fill_in :password, :with => @user.password
      click_button
      response.should render_template('user/show')
    end
    
    it "edit" do
      visit edit_user_path(@user)
      fill_in :email,    :with => @user.email
      fill_in :password, :with => @user.password
      click_button
      response.should render_template('user/edit')
    end
    
    it "users" do
      visit users_path
      fill_in :email,    :with => @user.email
      fill_in :password, :with => @user.password
      click_button
      response.should render_template('user/index')
    end
  end
end