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
      
      it "should display errors if data submitted to step 1 is invalid" do
        visit signup_path
        fill_in :email,                 :with => "testexample"
        fill_in :password,              :with => "password"
        fill_in :password_confirmation, :with => "passw"
        click_button
        response.should have_selector('div.flash.error', :content => I18n.t('flash.error.base'))
      end
      
      it "should display errors if data submitted to step 2 is invalid" do
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
      
      it "should sign a candidate up" do
        visit signup_path
        fill_in :email,                 :with => @attr[:email]
        fill_in :password,              :with => @attr[:password]
        fill_in :password_confirmation, :with => @attr[:password_confirmation]
        click_button
        response.should have_selector('h1', :content => I18n.t('users.edit.complete_your_profile'))
      end
      
      it "should sign a candidate up even after having submitted invalid data first" do
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
      
      it "should sign a candidate up and update his attributes after step 2" do
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
      
      it "should sign a candidate in even after having submitted empty fields first" do
        visit signin_path
        fill_in :email,    :with => ""
        fill_in :password, :with => ""
        click_button
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
      
      it "should sign a candidate in even after having already signed in/out" do
        visit signin_path
        fill_in :email,    :with => @candidate.email
        fill_in :password, :with => @candidate.password
        click_button
        click_link I18n.t(:sign_out)
        visit signin_path
        fill_in :email,    :with => @candidate.email
        fill_in :password, :with => @candidate.password
        click_button
        controller.should be_signed_in
      end
    end
  end

  describe "edit profile" do
    
    describe "for non-signed-in users" do
      
      it "should redirect to the signin page and display a message" do
        visit '/candidates/1/edit'
        current_url.should == "http://www.example.com#{signin_path}"
        response.should render_template(:signin_form)
        response.should have_selector('div.flash.notice', :content => I18n.t('flash.notice.please_signin'))
      end      
    end
    
    describe "for signed-in users" do
      
      before(:each) do
        @candidate = Factory(:candidate)
        @candidate.update_attributes(:profile_completion => 10)
        visit signin_path
        fill_in :email,    :with => @candidate.email
        fill_in :password, :with => @candidate.password
        click_button
      end
      
      describe "failure" do        
                
        it "should display an error to a candidate trying to edit another candidate's information" do          
          @another_candidate = Candidate.new(:first_name            => "Another",
                                             :last_name             => "Candidate",
                                             :email                 => "another_candidate@test.com",
                                             :password              => "another",
                                             :password_confirmation => "another",
                                             :status                => "available")
          @another_candidate.id = 1
          @another_candidate.save!
          visit '/candidates/1/edit'
          current_url.should == "http://www.example.com#{candidate_path(@candidate)}"
          response.should have_selector('div.flash.notice', :content => I18n.t('flash.notice.other_user_page'))
        end
        
        it "should display errors if the first name and/or last_name have been emptied" do
          visit edit_candidate_path(@candidate)
          fill_in :first_name, :with => ""
          fill_in :last_name,  :with => ""
          click_button
          response.should have_selector('div.flash.error', :content => I18n.t('flash.error.base'))
        end        
      end
      
      describe "success" do
        
        it "should update the candidate's information and redirect to his profile" do
          visit edit_candidate_path(@candidate)
          fill_in :first_name,    :with => "Jon"
          fill_in :last_name,     :with => "Von Der Mace"
          fill_in :year_of_birth, :with => 1975
          fill_in :country,       :with => "Netherlands" 
          click_button
          current_url.should == "http://www.example.com#{candidate_path(@candidate)}"
          response.should have_selector('div.flash.success', :content => I18n.t('flash.success.profile_updated'))
        end        
      end
    end
  end
end
