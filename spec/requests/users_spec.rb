require 'spec_helper'

describe "Users" do

  describe "signup" do
    
    describe "failure" do
      
      it "should not sign a user up" do
        visit signup_path
        fill_in :email,                 :with => "test@example.com"
        fill_in :password,              :with => "password"
        fill_in :password_confirmation, :with => "passwordd"
        click_button
        response.should have_selector('div.flash.error', :content => I18n.t('flash.error.base'))
      end
            
    end
    
    describe "success" do
      
      before(:each) do
        @attr = {:email                 => "test@example.com",
                 :password              => "password",
                 :password_confirmation => "password"}
      end
      
      it "should sign a user up" do
        visit signup_path
        fill_in :email,                 :with => @attr[:email]
        fill_in :password,              :with => @attr[:password]
        fill_in :password_confirmation, :with => @attr[:password_confirmation]
        click_button
        response.should have_selector('h1', :content => I18n.t('user.edit.complete_your_profile'))
      end
      
      it "should sign a user in" do
        visit signup_path
        fill_in :email,                 :with => @attr[:email]
        fill_in :password,              :with => @attr[:password]
        fill_in :password_confirmation, :with => @attr[:password_confirmation]
        click_button
        controller.should be_signed_in
      end
      
      it "should sign a user up even after having submitted invalid fields first" do
        visit signup_path
        fill_in :email,                 :with => "test@example.com"
        fill_in :password,              :with => "password"
        fill_in :password_confirmation, :with => "passwordd"
        click_button
        visit signup_path
        fill_in :email,                 :with => @attr[:email]
        fill_in :password,              :with => @attr[:password]
        fill_in :password_confirmation, :with => @attr[:password_confirmation]
        click_button
        response.should have_selector('h1', :content => I18n.t('user.edit.complete_your_profile'))
      end
      
    end
    
   ### to be completed ###
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
  
  describe "admin features" do
    
    before(:each) do
      @user = Factory(:user)
      visit signin_path
      fill_in :email,    :with => @user.email
      fill_in :password, :with => @user.password
      click_button
    end
    
   describe "admin users" do        
      
      before(:each) do
        @user.toggle!(:admin)
      end
      
      it "should have destroy links on the users page" do
        visit users_path
        response.should have_selector("a", :href => user_path(@user), :id => "destroy_user_#{@user.id}")
      end          
    end
  
    describe "non admin users" do
      
      it "should not have destroy links on the users page" do
        visit users_path
        response.should_not have_selector("a", :href => user_path(@user), :id => "destroy_user_#{@user.id}")
      end    
    end    
  end
end