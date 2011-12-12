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
      
      it "should display errors if the step II of signing up is not correctly done" do
        visit signup_path
        fill_in :email,                 :with => "test@example.com"
        fill_in :password,              :with => "password"
        fill_in :password_confirmation, :with => "password"
        click_button
        fill_in :first_name,            :with => ""
        fill_in :last_name,             :with => ""
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
        response.should have_selector('h1', :content => I18n.t('users.edit.complete_your_profile'))
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
        response.should have_selector('h1', :content => I18n.t('users.edit.complete_your_profile'))
      end
      
      it "should sign a user up and update his attributes once he passed step II" do
        visit signup_path
        fill_in :email,                 :with => "test@example.com"
        fill_in :password,              :with => "password"
        fill_in :password_confirmation, :with => "password"
        click_button
        fill_in :first_name,            :with => "Jack"
        fill_in :last_name,             :with => "Bauer"
        fill_in :year_of_birth,         :with => "1962"
        fill_in :country,               :with => "United States"
        click_button
        response.should have_selector('div.flash.success', :content => I18n.t('flash.success.welcome'))
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
        @user.update_attributes(:profile_completion => 10)
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
  
  describe "edit profile" do
    
    describe "for non-signed users" do
      
      it "should redirect the user to the signin page and display a message" do
        visit '/users/1/edit'
        current_url.should == "http://www.example.com#{signin_path}"
        response.should render_template(:signin_form)
        response.should have_selector('div.flash.notice', :content => I18n.t('flash.notice.please_signin'))
      end      
    end
    
    describe "for signed users" do
      
      before(:each) do
        @user = Factory(:user)
        @user.update_attributes(:profile_completion => 10)
        visit signin_path
        fill_in :email,    :with => @user.email
        fill_in :password, :with => @user.password
        click_button
      end
      
      describe "failure" do        
                
        it "should reject a user trying to edit another user's information" do          
          @another_user = User.new(:first_name            => "Another",
                                   :last_name             => "User",
                                   :email                 => "another_user@test.com",
                                   :password              => "another",
                                   :password_confirmation => "another")
          @another_user.id = 1
          @another_user.save!
          visit '/users/1/edit'
          current_url.should == "http://www.example.com#{user_path(@user)}"
          response.should have_selector('div.flash.notice', :content => I18n.t('flash.notice.other_user_page'))
        end
        
        it "should reject if the user empties the first name and/or last_name" do
          visit edit_user_path(@user)
          fill_in :first_name, :with => ""
          fill_in :last_name,  :with => ""
          click_button
          response.should have_selector('div.flash.error', :content => I18n.t('flash.error.base'))
        end        
      end
      
      describe "success" do
        
        it "should update the user's information and redirect to his profile" do
          visit edit_user_path(@user)
          fill_in :first_name,    :with => "Jon"
          fill_in :last_name,     :with => "Von Der Mace"
          fill_in :year_of_birth, :with => 1975
          fill_in :country,       :with => "Netherlands" 
          click_button
          current_url.should == "http://www.example.com#{user_path(@user)}"
          response.should have_selector('div.flash.success', :content => I18n.t('flash.success.profile_updated'))
        end        
      end
    end
    
  end
  
  describe "admin features" do
    
    before(:each) do
      @user = Factory(:user)
      @user.update_attributes(:profile_completion => 10)
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