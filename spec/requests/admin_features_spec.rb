require 'spec_helper'

describe 'AdminFeatures' do

  before :each do
    @admin = Factory :recruiter, :profile_completion => 5, :admin => true
    visit signin_path
    fill_in 'email',    :with => @admin.email
    fill_in 'password', :with => @admin.password
    click_button "#{I18n.t('sessions.new.signin')}"
  end
  
  describe "Candidates 'index'" do
    
    before :each do
      visit candidates_path
    end
    
    it 'should have a destroy link for each candidate' do 
      Candidate.all.each do |candidate|
        find("candidate_#{candidate.id}").should include "destroy_candidate_#{candidate.id}"
      end
    end
  end
  
  describe "Recruiters 'index'" do
    
    before :each do
      visit recruiters_path
    end
    
    it 'should have a destroy link for each recruiter' do 
      Recruiter.all.each do |recruiter|
        find("recruiter_#{recruiter.id}").should include "destroy_recruiter_#{recruiter.id}"
      end
    end
  end
end