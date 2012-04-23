require 'spec_helper'

describe 'PagesProtection' do
  
  before :each do
    @candidate1 = Factory :candidate
    @candidate2 = Factory :candidate, :email          => Factory.next(:email),          :facebook_login => Factory.next(:facebook_login),
                                      :linkedin_login => Factory.next(:linkedin_login), :twitter_login  => Factory.next(:twitter_login)
    @company1   = Factory :company
    @company2   = Factory :company
    @recruiter1 = Factory :recruiter, :company => @company1
    @recruiter2 = Factory :recruiter, :email          => Factory.next(:email),          :facebook_login => Factory.next(:facebook_login),
                                      :linkedin_login => Factory.next(:linkedin_login), :twitter_login  => Factory.next(:twitter_login), :company => @company2
  end
  
  describe 'Candidates' do
    
    describe "'index'" do
      
      it 'should deny access to non signed-in users' do
        visit candidates_path
        current_path.should_not == candidates_path
        current_path.should     == signin_path
        find('div.flash.notice').should have_content I18n.t('flash.notice.please_signin')
      end
      
      it "should deny access to signed-in candidates who haven't completed signup" do
        visit signin_path
        fill_in 'email',    :with => @candidate1.email
        fill_in 'password', :with => @candidate1.password
        click_button I18n.t('sessions.new.signin')
        visit candidates_path
        current_path.should_not == candidates_path
        current_path.should     == edit_candidate_path(@candidate1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.please_finish_signup')
      end
      
      it 'should deny access to signed-in candidates who have completed signup' do
        @candidate1.update_attributes :profile_completion => 5
        visit signin_path
        fill_in 'email',    :with => @candidate1.email
        fill_in 'password', :with => @candidate1.password
        click_button I18n.t('sessions.new.signin')
        visit candidates_path
        current_path.should_not == candidates_path
        current_path.should     == candidate_path(@candidate1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.restricted_page')
      end
      
      it "should deny access to signed-in recruiters who haven't completed signup" do
        visit signin_path
        fill_in 'email',    :with => @recruiter1.email
        fill_in 'password', :with => @recruiter1.password
        click_button I18n.t('sessions.new.signin')
        visit candidates_path
        current_path.should_not == candidates_path
        current_path.should     == edit_recruiter_path(@recruiter1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.please_finish_signup')
      end
      
      it 'should grant access to signed-in recruiters who have completed signup' do
        @recruiter1.update_attributes :profile_completion => 5
        visit signin_path
        fill_in 'email',    :with => @recruiter1.email
        fill_in 'password', :with => @recruiter1.password
        click_button I18n.t('sessions.new.signin')
        visit candidates_path
        current_path.should == candidates_path
      end
    end
    
    describe "'show'" do
      
      it 'should deny access to non signed-in users' do
        visit candidate_path(@candidate2)
        current_path.should_not == candidate_path(@candidate2)
        current_path.should     == signin_path
        find('div.flash.notice').should have_content I18n.t('flash.notice.please_signin')
      end
      
      it "should deny access to signed-in candidates who haven't completed signup and visit another candidate's profile'" do
        visit signin_path
        fill_in 'email',    :with => @candidate1.email
        fill_in 'password', :with => @candidate1.password
        click_button I18n.t('sessions.new.signin')
        visit candidate_path(@candidate2)
        current_path.should_not == candidate_path(@candidate2)
        current_path.should     == edit_candidate_path(@candidate1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.please_finish_signup')
      end
      
      it "should deny access to signed-in candidates who haven't completed signup and visit their own profile'" do
        visit signin_path
        fill_in 'email',    :with => @candidate1.email
        fill_in 'password', :with => @candidate1.password
        click_button I18n.t('sessions.new.signin')
        visit candidate_path(@candidate1)
        current_path.should_not == candidate_path(@candidate2)
        current_path.should     == edit_candidate_path(@candidate1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.please_finish_signup')
      end
      
      it "should deny access to signed-in candidates who have completed signup and visit another candidate's profile'" do
        @candidate1.update_attributes :profile_completion => 5
        visit signin_path
        fill_in 'email',    :with => @candidate1.email
        fill_in 'password', :with => @candidate1.password
        click_button I18n.t('sessions.new.signin')
        visit candidate_path(@candidate2)
        current_path.should_not == candidate_path(@candidate2)
        current_path.should     == candidate_path(@candidate1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.restricted_page')
      end
      
      it 'should grant access to signed-in candidates who have completed signup and visit their own profile' do
        @candidate1.update_attributes :profile_completion => 5
        visit signin_path
        fill_in 'email',    :with => @candidate1.email
        fill_in 'password', :with => @candidate1.password
        click_button I18n.t('sessions.new.signin')
        visit candidate_path(@candidate1)
        current_path.should == candidate_path(@candidate1)
      end
      
      it "should deny access to signed-in recruiters who haven't completed signup" do
        visit signin_path
        fill_in 'email',    :with => @recruiter1.email
        fill_in 'password', :with => @recruiter1.password
        click_button I18n.t('sessions.new.signin')
        visit candidate_path(@candidate2)
        current_path.should_not == candidate_path(@candidate2)
        current_path.should     == edit_recruiter_path(@recruiter1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.please_finish_signup')
      end
      
      it 'should grant access to signed-in recruiters who have completed signup' do
        @recruiter1.update_attributes :profile_completion => 5
        visit signin_path
        fill_in 'email',    :with => @recruiter1.email
        fill_in 'password', :with => @recruiter1.password
        click_button I18n.t('sessions.new.signin')
        visit candidate_path(@candidate2)
        current_path.should == candidate_path(@candidate2)
      end
    end
    
    describe "'new'" do
      
      it 'should grant access to non signed-in users' do
        visit new_candidate_path
        current_path.should == new_candidate_path
      end
      
      it 'should deny access to signed-in candidates who have completed signup' do
        @candidate1.update_attributes :profile_completion => 5
        visit signin_path
        fill_in 'email',    :with => @candidate1.email
        fill_in 'password', :with => @candidate1.password
        click_button I18n.t('sessions.new.signin')
        visit new_candidate_path
        current_path.should_not == new_candidate_path
        current_path.should     == candidate_path(@candidate1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.not_a_new_user')
      end
      
      it "should deny access to signed-in candidates who haven't completed signup" do
        visit signin_path
        fill_in 'email',    :with => @candidate1.email
        fill_in 'password', :with => @candidate1.password
        click_button I18n.t('sessions.new.signin')
        visit new_candidate_path
        current_path.should_not == new_candidate_path
        current_path.should     == edit_candidate_path(@candidate1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.please_finish_signup')
      end
      
      it 'should deny access to signed-in recruiters who have completed signup' do
        @recruiter1.update_attributes :profile_completion => 5
        visit signin_path
        fill_in 'email',    :with => @recruiter1.email
        fill_in 'password', :with => @recruiter1.password
        click_button I18n.t('sessions.new.signin')
        visit new_candidate_path
        current_path.should_not == new_candidate_path
        current_path.should     == recruiter_path(@recruiter1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.not_a_new_user')
      end
      
      it "should deny access to signed-in recruiters who haven't completed signup" do
        visit signin_path
        fill_in 'email',    :with => @recruiter1.email
        fill_in 'password', :with => @recruiter1.password
        click_button I18n.t('sessions.new.signin')
        visit new_candidate_path
        current_path.should_not == new_candidate_path
        current_path.should     == edit_recruiter_path(@recruiter1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.please_finish_signup')
      end
    end
    
    describe 'edit' do
      
      it 'should deny access to non signed-in users' do
        visit edit_candidate_path(@candidate1)
        current_path.should_not == edit_candidate_path(@candidate1)
        current_path.should     == signin_path
      end
      
      it "should deny access to signed-in candidates who haven't completed signup and are trying to edit another candidate's profile" do
        visit signin_path
        fill_in 'email',    :with => @candidate1.email
        fill_in 'password', :with => @candidate1.password
        click_button I18n.t('sessions.new.signin')
        visit edit_candidate_path(@candidate2)
        current_path.should_not == edit_candidate_path(@candidate2)
        current_path.should     == edit_candidate_path(@candidate1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.please_finish_signup')
      end
      
      it "should grant access to signed-in candidates who haven't completed signup are trying to edit their own profile" do
        visit signin_path
        fill_in 'email',    :with => @candidate1.email
        fill_in 'password', :with => @candidate1.password
        click_button I18n.t('sessions.new.signin')
        visit edit_candidate_path(@candidate1)
        current_path.should     == edit_candidate_path(@candidate1)
      end
      
      it "should deny access to signed-in candidates who have completed signup and are trying to edit another candidate's profile" do
        @candidate1.update_attributes :profile_completion => 5
        visit signin_path
        fill_in 'email',    :with => @candidate1.email
        fill_in 'password', :with => @candidate1.password
        click_button I18n.t('sessions.new.signin')
        visit edit_candidate_path(@candidate2)
        current_path.should_not == edit_candidate_path(@candidate2)
        current_path.should     == candidate_path(@candidate1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.other_user_page')
      end
      
      it "should deny access to signed-in candidates who have completed signup are trying to edit their own profile" do
        @candidate1.update_attributes :profile_completion => 5
        visit signin_path
        fill_in 'email',    :with => @candidate1.email
        fill_in 'password', :with => @candidate1.password
        click_button I18n.t('sessions.new.signin')
        visit edit_candidate_path(@candidate1)
        current_path.should_not == edit_candidate_path(@candidate1)
        current_path.should     == candidate_path(@candidate1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.already_signed_up')
      end
      
      it "should deny access to signed-in recruiters who haven't completed signup" do
        visit signin_path
        fill_in 'email',    :with => @recruiter1.email
        fill_in 'password', :with => @recruiter1.password
        click_button I18n.t('sessions.new.signin')
        visit edit_candidate_path(@candidate2)
        current_path.should_not == edit_candidate_path(@candidate2)
        current_path.should     == edit_recruiter_path(@recruiter1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.please_finish_signup')
      end
      
      it "should deny access to signed-in recruiters who have completed signup" do
        @recruiter1.update_attributes :profile_completion => 5
        visit signin_path
        fill_in 'email',    :with => @recruiter1.email
        fill_in 'password', :with => @recruiter1.password
        click_button I18n.t('sessions.new.signin')
        visit edit_candidate_path(@candidate2)
        current_path.should_not == edit_candidate_path(@candidate2)
        current_path.should     == recruiter_path(@recruiter1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.other_user_page')
      end
    end
  end
  
  describe 'Recruiters' do
    
    describe "'index'" do
      
      it 'should deny access to non signed-in users' do
        visit recruiters_path
        current_path.should_not == recruiters_path
        current_path.should     == signin_path
        find('div.flash.notice').should have_content I18n.t('flash.notice.please_signin')
      end
      
      it "should deny access to signed-in recruiters who haven't completed signup" do
        visit signin_path
        fill_in 'email',    :with => @recruiter1.email
        fill_in 'password', :with => @recruiter1.password
        click_button I18n.t('sessions.new.signin')
        visit recruiters_path
        current_path.should_not == recruiters_path
        current_path.should     == edit_recruiter_path(@recruiter1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.please_finish_signup')
      end
      
      it 'should deny access to signed-in recruiters who have completed signup' do
        @recruiter1.update_attributes :profile_completion => 5
        visit signin_path
        fill_in 'email',    :with => @recruiter1.email
        fill_in 'password', :with => @recruiter1.password
        click_button I18n.t('sessions.new.signin')
        visit recruiters_path
        current_path.should_not == recruiters_path
        current_path.should     == recruiter_path(@recruiter1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.restricted_page')
      end
      
      it "should deny access to signed-in candidates who haven't completed signup" do
        visit signin_path
        fill_in 'email',    :with => @candidate1.email
        fill_in 'password', :with => @candidate1.password
        click_button I18n.t('sessions.new.signin')
        visit recruiters_path
        current_path.should_not == recruiters_path
        current_path.should     == edit_candidate_path(@candidate1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.please_finish_signup')
      end
      
      it 'should grant access to signed-in candidates who have completed signup' do
        @candidate1.update_attributes :profile_completion => 5
        visit signin_path
        fill_in 'email',    :with => @candidate1.email
        fill_in 'password', :with => @candidate1.password
        click_button I18n.t('sessions.new.signin')
        visit recruiters_path
        current_path.should == recruiters_path
      end
    end
    
    describe "'show'" do
      
      it 'should deny access to non signed-in users' do
        visit recruiter_path(@recruiter2)
        current_path.should_not == recruiter_path(@recruiter2)
        current_path.should     == signin_path
        find('div.flash.notice').should have_content I18n.t('flash.notice.please_signin')
      end
      
      it "should deny access to signed-in recruiters who haven't completed signup and visit another recruiter's profile'" do
        visit signin_path
        fill_in 'email',    :with => @recruiter1.email
        fill_in 'password', :with => @recruiter1.password
        click_button I18n.t('sessions.new.signin')
        visit recruiter_path(@recruiter2)
        current_path.should_not == recruiter_path(@recruiter2)
        current_path.should     == edit_recruiter_path(@recruiter1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.please_finish_signup')
      end
      
      it "should deny access to signed-in recruiters who haven't completed signup and visit their own profile'" do
        visit signin_path
        fill_in 'email',    :with => @recruiter1.email
        fill_in 'password', :with => @recruiter1.password
        click_button I18n.t('sessions.new.signin')
        visit recruiter_path(@recruiter1)
        current_path.should_not == recruiter_path(@recruiter2)
        current_path.should     == edit_recruiter_path(@recruiter1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.please_finish_signup')
      end
      
      it "should deny access to signed-in recruiters who have completed signup and visit another recruiter's profile'" do
        @recruiter1.update_attributes :profile_completion => 5
        visit signin_path
        fill_in 'email',    :with => @recruiter1.email
        fill_in 'password', :with => @recruiter1.password
        click_button I18n.t('sessions.new.signin')
        visit recruiter_path(@recruiter2)
        current_path.should_not == recruiter_path(@recruiter2)
        current_path.should     == recruiter_path(@recruiter1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.restricted_page')
      end
      
      it 'should grant access to signed-in recruiters who have completed signup and visit their own profile' do
        @recruiter1.update_attributes :profile_completion => 5
        visit signin_path
        fill_in 'email',    :with => @recruiter1.email
        fill_in 'password', :with => @recruiter1.password
        click_button I18n.t('sessions.new.signin')
        visit recruiter_path(@recruiter1)
        current_path.should == recruiter_path(@recruiter1)
      end
      
      it "should deny access to signed-in candidates who haven't completed signup" do
        visit signin_path
        fill_in 'email',    :with => @candidate1.email
        fill_in 'password', :with => @candidate1.password
        click_button I18n.t('sessions.new.signin')
        visit recruiter_path(@recruiter2)
        current_path.should_not == recruiter_path(@recruiter2)
        current_path.should     == edit_candidate_path(@candidate1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.please_finish_signup')
      end
      
      it 'should grant access to signed-in candidates who have completed signup' do
        @candidate1.update_attributes :profile_completion => 5
        visit signin_path
        fill_in 'email',    :with => @candidate1.email
        fill_in 'password', :with => @candidate1.password
        click_button I18n.t('sessions.new.signin')
        visit recruiter_path(@recruiter2)
        current_path.should == recruiter_path(@recruiter2)
      end
    end
    
    describe "'new'" do
      
      it 'should grant access to non signed-in users' do
        visit new_recruiter_path
        current_path.should == new_recruiter_path
      end
      
      it 'should deny access to signed-in recruiters who have completed signup' do
        @recruiter1.update_attributes :profile_completion => 5
        visit signin_path
        fill_in 'email',    :with => @recruiter1.email
        fill_in 'password', :with => @recruiter1.password
        click_button I18n.t('sessions.new.signin')
        visit new_recruiter_path
        current_path.should_not == new_recruiter_path
        current_path.should     == recruiter_path(@recruiter1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.not_a_new_user')
      end
      
      it "should deny access to signed-in recruiters who haven't completed signup" do
        visit signin_path
        fill_in 'email',    :with => @recruiter1.email
        fill_in 'password', :with => @recruiter1.password
        click_button I18n.t('sessions.new.signin')
        visit new_recruiter_path
        current_path.should_not == new_recruiter_path
        current_path.should     == edit_recruiter_path(@recruiter1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.please_finish_signup')
      end
      
      it 'should deny access to signed-in candidates who have completed signup' do
        @candidate1.update_attributes :profile_completion => 5
        visit signin_path
        fill_in 'email',    :with => @candidate1.email
        fill_in 'password', :with => @candidate1.password
        click_button I18n.t('sessions.new.signin')
        visit new_recruiter_path
        current_path.should_not == new_recruiter_path
        current_path.should     == candidate_path(@candidate1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.not_a_new_user')
      end
      
      it "should deny access to signed-in candidates who haven't completed signup" do
        visit signin_path
        fill_in 'email',    :with => @candidate1.email
        fill_in 'password', :with => @candidate1.password
        click_button I18n.t('sessions.new.signin')
        visit new_recruiter_path
        current_path.should_not == new_recruiter_path
        current_path.should     == edit_candidate_path(@candidate1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.please_finish_signup')
      end
    end
    
    describe 'edit' do
      
      it 'should deny access to non signed-in users' do
        visit edit_recruiter_path(@recruiter1)
        current_path.should_not == edit_recruiter_path(@recruiter1)
        current_path.should     == signin_path
      end
      
      it "should deny access to signed-in recruiters who haven't completed signup and are trying to edit another recruiter's profile" do
        visit signin_path
        fill_in 'email',    :with => @recruiter1.email
        fill_in 'password', :with => @recruiter1.password
        click_button I18n.t('sessions.new.signin')
        visit edit_recruiter_path(@recruiter2)
        current_path.should_not == edit_recruiter_path(@recruiter2)
        current_path.should     == edit_recruiter_path(@recruiter1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.please_finish_signup')
      end
      
      it "should grant access to signed-in recruiters who haven't completed signup are trying to edit their own profile" do
        visit signin_path
        fill_in 'email',    :with => @recruiter1.email
        fill_in 'password', :with => @recruiter1.password
        click_button I18n.t('sessions.new.signin')
        visit edit_recruiter_path(@recruiter1)
        current_path.should     == edit_recruiter_path(@recruiter1)
      end
      
      it "should deny access to signed-in recruiters who have completed signup and are trying to edit another recruiter's profile" do
        @recruiter1.update_attributes :profile_completion => 5
        visit signin_path
        fill_in 'email',    :with => @recruiter1.email
        fill_in 'password', :with => @recruiter1.password
        click_button I18n.t('sessions.new.signin')
        visit edit_recruiter_path(@recruiter2)
        current_path.should_not == edit_recruiter_path(@recruiter2)
        current_path.should     == recruiter_path(@recruiter1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.other_user_page')
      end
      
      it "should deny access to signed-in recruiters who have completed signup are trying to edit their own profile" do
        @recruiter1.update_attributes :profile_completion => 5
        visit signin_path
        fill_in 'email',    :with => @recruiter1.email
        fill_in 'password', :with => @recruiter1.password
        click_button I18n.t('sessions.new.signin')
        visit edit_recruiter_path(@recruiter1)
        current_path.should_not == edit_recruiter_path(@recruiter1)
        current_path.should     == recruiter_path(@recruiter1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.already_signed_up')
      end
      
      it "should deny access to signed-in candidates who haven't completed signup" do
        visit signin_path
        fill_in 'email',    :with => @candidate1.email
        fill_in 'password', :with => @candidate1.password
        click_button I18n.t('sessions.new.signin')
        visit edit_recruiter_path(@recruiter2)
        current_path.should_not == edit_recruiter_path(@recruiter2)
        current_path.should     == edit_candidate_path(@candidate1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.please_finish_signup')
      end
      
      it "should deny access to signed-in candidates who have completed signup" do
        @candidate1.update_attributes :profile_completion => 5
        visit signin_path
        fill_in 'email',    :with => @candidate1.email
        fill_in 'password', :with => @candidate1.password
        click_button I18n.t('sessions.new.signin')
        visit edit_recruiter_path(@recruiter2)
        current_path.should_not == edit_recruiter_path(@recruiter2)
        current_path.should     == candidate_path(@candidate1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.other_user_page')
      end
    end
  end

  describe 'Companies' do
    
    describe "'show'" do
      
      it 'should deny access to non signed-in users' do
        visit company_path(@company1)
        current_path.should_not == company_path(@company1)
        current_path.should     == signin_path
      end
      
      it "should deny access to signed-in candidates who haven't completed signup" do
        visit signin_path
        fill_in 'email',    :with => @candidate1.email
        fill_in 'password', :with => @candidate1.password
        click_button I18n.t('sessions.new.signin')
        visit company_path(@company1)
        current_path.should_not == company_path(@company1)
        current_path.should     == edit_candidate_path(@candidate1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.please_finish_signup')
      end
      
      it "grant access to signed-in candidates who have completed signup" do
        @candidate1.update_attributes :profile_completion => 5
        visit signin_path
        fill_in 'email',    :with => @candidate1.email
        fill_in 'password', :with => @candidate1.password
        click_button I18n.t('sessions.new.signin')
        visit company_path(@company1)
        current_path.should == company_path(@company1)
      end
      
      it "should deny access to signed-in recruiters who haven't completed signup and visit another company's profile" do
        visit signin_path
        fill_in 'email',    :with => @recruiter1.email
        fill_in 'password', :with => @recruiter1.password
        click_button I18n.t('sessions.new.signin')
        visit company_path(@company2)
        current_path.should_not == company_path(@company2)
        current_path.should     == edit_recruiter_path(@recruiter1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.please_finish_signup')
      end
      
      it "should deny access to signed-in recruiters who have completed signup and visit another company's profile" do
        @recruiter1.update_attributes :profile_completion => 5
        visit signin_path
        fill_in 'email',    :with => @recruiter1.email
        fill_in 'password', :with => @recruiter1.password
        click_button I18n.t('sessions.new.signin')
        visit company_path(@company2)
        current_path.should_not == company_path(@company2)
        current_path.should     == recruiter_path(@recruiter1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.restricted_page')
      end
      
      it "should grant access to signed-in recruiters who have completed signup and visit their own company's profile" do
        @recruiter1.update_attributes :profile_completion => 5
        visit signin_path
        fill_in 'email',    :with => @recruiter1.email
        fill_in 'password', :with => @recruiter1.password
        click_button I18n.t('sessions.new.signin')
        visit company_path(@company1)
        current_path.should == company_path(@company1)
      end
    end
  end
  
  describe 'Messages' do
    
    describe "'show'" do
      it 'should deny access to non signed-in users' do
        visit messages_path
        current_path.should_not == messages_path
        current_path.should     == signin_path
      end
      
      it "should deny access to signed-in candidates who haven't completed signup" do
        visit signin_path
        fill_in 'email',    :with => @candidate1.email
        fill_in 'password', :with => @candidate1.password
        click_button I18n.t('sessions.new.signin')
        visit messages_path
        current_path.should_not == messages_path
        current_path.should     == edit_candidate_path(@candidate1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.please_finish_signup')
      end
      
      it "grant access to signed-in candidates who have completed signup" do
        @candidate1.update_attributes :profile_completion => 5
        visit signin_path
        fill_in 'email',    :with => @candidate1.email
        fill_in 'password', :with => @candidate1.password
        click_button I18n.t('sessions.new.signin')
        visit messages_path
        current_path.should == messages_path
      end
      
      it "should deny access to signed-in recruiters who haven't completed signup" do
        visit signin_path
        fill_in 'email',    :with => @recruiter1.email
        fill_in 'password', :with => @recruiter1.password
        click_button I18n.t('sessions.new.signin')
        visit messages_path
        current_path.should_not == messages_path
        current_path.should     == edit_recruiter_path(@recruiter1)
        find('div.flash.notice').should have_content I18n.t('flash.notice.please_finish_signup')
      end
      
      it "grant access to signed-in recruiters who have completed signup" do
        @recruiter1.update_attributes :profile_completion => 5
        visit signin_path
        fill_in 'email',    :with => @recruiter1.email
        fill_in 'password', :with => @recruiter1.password
        click_button I18n.t('sessions.new.signin')
        visit messages_path
        current_path.should == messages_path
      end
    end
  end
end