require 'spec_helper'

describe 'NotSignedUp' do
  
  before :each do
    @candidate  = Factory :candidate, :profile_completion => 5
    @recruiter  = Factory :recruiter, :profile_completion => 5
  end
  
  after :each do
    find('div.flash.notice').should have_content I18n.t('flash.notice.already_signed_up')
  end
  
  it "should prevent candidates who have completed signup from Candidates 'edit'" do
    visit edit_candidate_path(@candidate)
    fill_in 'email',    :with => @candidate.email
    fill_in 'password', :with => @candidate.password
    click_button I18n.t('sessions.new.signin')
    current_path.should_not == edit_candidate_path(@candidate)
    current_path.should == candidate_path(@candidate)
  end
  
  it "should prevent recruiters who have completed signup from accessing Recruiters 'edit'" do
    visit edit_recruiter_path(@recruiter)
    fill_in 'email',    :with => @recruiter.email
    fill_in 'password', :with => @recruiter.password
    click_button I18n.t('sessions.new.signin')
    current_path.should_not == edit_recruiter_path(@recruiter)
    current_path.should == recruiter_path(@recruiter)
  end
end  
