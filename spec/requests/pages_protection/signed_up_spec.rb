require 'spec_helper'

describe 'SignedUp' do
  
  before :each do
    @candidate = Factory :candidate
    @recruiter = Factory :recruiter
    @company   = Factory :company
    @message   = Factory :message, :author => @candidate, :recipient => @recruiter
    visit signin_path
  end
  
  after :each do
    find('div.flash.notice').should have_content I18n.t('flash.notice.please_finish_signup')
  end
  
  describe "should prevent candidates who haven't completed signup from accessing" do
    
    before :each do
      fill_in 'email',    :with => @candidate.email
      fill_in 'password', :with => @candidate.password
      click_button I18n.t('sessions.new.signin')
    end
    
    after :each do
      current_path.should == edit_candidate_path(@candidate)
    end
    
    describe 'Candidates' do
    
      it "'index'" do
        visit candidates_path
        current_path.should_not == candidates_path
      end
    
      it "'show'" do
        visit candidate_path(@candidate)
        current_path.should_not == candidate_path(@candidate)
      end
    end
  
    describe 'Recruiters' do
    
      it "'index'" do
        visit recruiters_path
        current_path.should_not == recruiters_path
      end
    
      it "'show'" do
        visit recruiter_path(@recruiter)
        current_path.should_not == recruiter_path(@recruiter)
      end
    end

    describe 'Companies' do
    
      it "'show'" do
        visit company_path(@company)
        current_path.should_not == company_path(@company)
      end
    end
  
    describe 'Messages' do
    
      it "'index'" do
        visit messages_path
        current_path.should_not == messages_path
      end
      
      it "'show'" do
        visit message_path(@message)
        current_path.should_not == message_path(@message)
      end
    end
  end
  
  describe "should prevent recruiters who haven't completed signup from accessing" do
    
    before :each do
      fill_in 'email',    :with => @recruiter.email
      fill_in 'password', :with => @recruiter.password
      click_button I18n.t('sessions.new.signin')
    end
    
    after :each do
      current_path.should == edit_recruiter_path(@recruiter)
    end
    
    describe 'Candidates' do
    
      it "'index'" do
        visit candidates_path
        current_path.should_not == candidates_path
      end
    
      it "'show'" do
        visit candidate_path(@candidate)
        current_path.should_not == candidate_path(@candidate)
      end
    end
  
    describe 'Recruiters' do
    
      it "'index'" do
        visit recruiters_path
        current_path.should_not == recruiters_path
      end
    
      it "'show'" do
        visit recruiter_path(@recruiter)
        current_path.should_not == recruiter_path(@recruiter)
      end
    end

    describe 'Companies' do
    
      it "'show'" do
        visit company_path(@company)
        current_path.should_not == company_path(@company)
      end
    end
  
    describe 'Messages' do
    
      it "'index'" do
        visit messages_path
        current_path.should_not == messages_path
      end
      
      it "'show'" do
        visit message_path(@message)
        current_path.should_not == message_path(@message)
      end
    end
  end
end