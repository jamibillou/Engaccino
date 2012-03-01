require 'spec_helper'

describe "Users" do
      
  describe "admin features" do
    
    before(:each) do
      @candidate = Factory(:candidate)
      @candidate.update_attributes(:profile_completion => 10)
      visit signin_path
      fill_in :email,    :with => @candidate.email
      fill_in :password, :with => @candidate.password
      click_button
    end
    
    describe "admin users" do        
      
      before(:each) do
        @candidate.toggle!(:admin)
      end
      
      it "should have destroy links on the users page" # do
       #        visit users_path
       #        response.should have_selector("a", :href => candidate_path(@candidate), :id => "destroy_candidate_#{@candidate.id}")
       #      end          
    end
  
    describe "non admin users" do
      
      it "should not have destroy links on the users page" # do
      #         visit users_path
      #         response.should_not have_selector("a", :href => candidate_path(@candidate), :id => "destroy_candidate_#{@candidate.id}")
      #       end    
    end    
  end
end