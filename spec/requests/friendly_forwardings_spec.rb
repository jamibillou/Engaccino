require 'spec_helper'

describe "FriendlyForwardings" do

  before(:each) do
    @candidate = Factory(:candidate)
  end
  
  describe "should forward to the requested page after signin" do
    
    before(:each) do
      @candidate.update_attributes(:profile_completion => 10)
    end
    
    it "profile" do
      visit candidate_path(@candidate)
      fill_in :email,    :with => @candidate.email
      fill_in :password, :with => @candidate.password
      click_button
      response.should render_template('candidates/show')
    end
    
    it "edit" do
      visit edit_candidate_path(@candidate)
      fill_in :email,    :with => @candidate.email
      fill_in :password, :with => @candidate.password
      click_button
      response.should render_template('candidates/edit')
    end
    
    it "users" do
      visit candidates_path
      fill_in :email,    :with => @candidate.email
      fill_in :password, :with => @candidate.password
      click_button
      response.should render_template('candidates/index')
    end
  end
end