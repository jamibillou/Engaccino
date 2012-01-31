require 'spec_helper'

describe "Candidates" do

  describe "signup" do
    
    describe "failure" do
      
      it "should not sign a candidate up" do
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
      
      it "should sign a candidate up" do
        visit signup_path
        fill_in :email,                 :with => "test@example.com"
        fill_in :password,              :with => "password"
        fill_in :password_confirmation, :with => "password"
        click_button
        fill_in :first_name,            :with => "Jack"
        fill_in :last_name,             :with => "Bauer"
        fill_in :year_of_birth,         :with => 1962
        fill_in :country,               :with => "United States"
        click_button
        response.should have_selector('div.flash.success', :content => I18n.t('flash.success.welcome'))
      end
    end
  end

  describe "sign in/out" do
  
    describe "failure" do
    
      it "should not sign a candidate in" do
        visit signin_path
        fill_in :email,    :with => ""
        fill_in :password, :with => ""
        click_button
        response.should have_selector("div.flash.error", :content => I18n.t('flash.error.signin'))
      end
    end
  
    describe "success" do
    
      before(:each) do
        @candidate = Factory(:candidate)
        @candidate.update_attributes(:profile_completion => 10)
      end
      
      it "should sign a candidate in" do
        visit signin_path
        fill_in :email,    :with => @candidate.email
        fill_in :password, :with => @candidate.password
        click_button
        controller.should be_signed_in
      end
      
      it "should sign a candidate out" do
        visit signin_path
        fill_in :email,    :with => @candidate.email
        fill_in :password, :with => @candidate.password
        click_button
        click_link I18n.t(:sign_out)
        controller.should_not be_signed_in
      end
    end
  end
end
