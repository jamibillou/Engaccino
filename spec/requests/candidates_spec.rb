require 'spec_helper'

describe "Candidates" do

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
