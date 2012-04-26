require 'spec_helper'

describe 'NewUser' do
  
  before :each do
    @candidate = Factory :candidate, :profile_completion => 5
    @recruiter = Factory :recruiter, :profile_completion => 5
    visit signin_path
  end
  
  after :each do
    find('div.flash.notice').should have_content I18n.t('flash.notice.not_a_new_user')
  end
  
  describe "should prevent candidates who haven completed signup from accessing" do
    
    before :each do
      fill_in 'email',    :with => @candidate.email
      fill_in 'password', :with => @candidate.password
      click_button I18n.t('sessions.new.signin')
    end
    
    after :each do
      current_path.should == candidate_path(@candidate)
    end
    
    it "Candidates 'new'" do
      visit new_candidate_path
      current_path.should_not == new_candidate_path
    end
    
    it "Recruiters 'new'" do
      visit new_recruiter_path
      current_path.should_not == new_recruiter_path
    end
  end
  
  describe "should prevent candidates who haven completed signup from accessing" do
    
    before :each do
      fill_in 'email',    :with => @recruiter.email
      fill_in 'password', :with => @recruiter.password
      click_button I18n.t('sessions.new.signin')
    end
    
    after :each do
      current_path.should == recruiter_path(@recruiter)
    end
    
    it "Candidates 'new'" do
      visit new_candidate_path
      current_path.should_not == new_candidate_path
    end
    
    it "Recruiters 'new'" do
      visit new_recruiter_path
      current_path.should_not == new_recruiter_path
    end
  end
end