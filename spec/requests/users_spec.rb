require 'spec_helper'

describe "Users" do

  describe "signup" do
   ### to be written ###
  end
  
  describe "sign in/out" do
  
    describe "failure" do
    
      it "should not sign a user in" do
        visit signin_path
        fill_in :email,    :with => ""
        fill_in :password, :with => ""
        click_button
        response.should have_selector("div.flash.error", :content => I18n.t('flash.error.signin'))
      end
    end
  
    describe "success" do
    
      before(:each) do
        @user = Factory(:user)
      end
      
      it "should sign a user in" do
        visit signin_path
        fill_in :email,    :with => @user.email
        fill_in :password, :with => @user.password
        click_button
        controller.should be_signed_in
      end
      
      it "should sign a user in even after having submitted empty fields first" do
        visit signin_path
        fill_in :email,    :with => ""
        fill_in :password, :with => ""
        click_button
        visit signin_path
        fill_in :email,    :with => @user.email
        fill_in :password, :with => @user.password
        click_button
        controller.should be_signed_in
      end
      
      it "should sign a user in even after an email/password mismatch" do
        visit signin_path
        fill_in :email,    :with => @user.email
        fill_in :password, :with => "pouetpouet"
        click_button
        visit signin_path
        fill_in :email,    :with => @user.email
        fill_in :password, :with => @user.password
        click_button
        controller.should be_signed_in
      end
      
      it "should sign a user out" do
        visit signin_path
        fill_in :email,    :with => @user.email
        fill_in :password, :with => @user.password
        click_button
        click_link I18n.t(:sign_out)
        controller.should_not be_signed_in
      end
      
      it "should sign a user in even after having already signed in/out" do
        visit signin_path
        fill_in :email,    :with => @user.email
        fill_in :password, :with => @user.password
        click_button
        click_link I18n.t(:sign_out)
        visit signin_path
        fill_in :email,    :with => @user.email
        fill_in :password, :with => @user.password
        click_button
        controller.should be_signed_in
      end
    end
  end
end