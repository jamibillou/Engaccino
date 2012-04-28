require 'spec_helper'

describe 'Authorized' do
  
  before :each do
    @candidate  = Factory :candidate, :profile_completion => 5
    @candidate2 = Factory :candidate, :email          => Factory.next(:email),          :facebook_login => Factory.next(:facebook_login),
                                      :linkedin_login => Factory.next(:linkedin_login), :twitter_login  => Factory.next(:twitter_login), :profile_completion => 5
    @company    = Factory :company
    @company2   = Factory :company
    @recruiter  = Factory :recruiter, :company => @company, :profile_completion => 5
    @recruiter2 = Factory :recruiter, :email          => Factory.next(:email),          :facebook_login => Factory.next(:facebook_login),
                                      :linkedin_login => Factory.next(:linkedin_login), :twitter_login  => Factory.next(:twitter_login), :company => @company2, :profile_completion => 5
    visit signin_path
  end
  
  after :each do
    find('div.flash.notice').should have_content I18n.t('flash.notice.restricted_page')
  end
  
  describe "should prevent candidates from accessing" do
    
    before :each do
      fill_in 'email',    :with => @candidate.email
      fill_in 'password', :with => @candidate.password
      click_button I18n.t('sessions.new.signin')
    end
    
    after :each do
      current_path.should == candidate_path(@candidate)
    end
    
    describe 'Candidates' do
    
      it "'index'" do
        visit candidates_path
        current_path.should_not == candidates_path
      end
    
      it "'show' another candidate's profile" do
        visit candidate_path(@candidate2)
        current_path.should_not == candidate_path(@candidate2)
      end
    end
  end
  
  describe "should prevent recruiters from accessing" do
    
    before :each do
      fill_in 'email',    :with => @recruiter.email
      fill_in 'password', :with => @recruiter.password
      click_button I18n.t('sessions.new.signin')
    end
    
    after :each do
      current_path.should == recruiter_path(@recruiter)
    end
    
    describe 'Companies' do
    
      it "'show' another company's profile" do
        visit company_path(@company2)
        current_path.should_not == company_path(@company2)
      end
    end
  
    describe 'Recruiters' do
    
      it "'index'" do
        visit recruiters_path
        current_path.should_not == recruiters_path
      end
    
      it "'show' another recruiter's profile" do
        visit recruiter_path(@recruiter2)
        current_path.should_not == recruiter_path(@recruiter2)
      end
    end
  end
end