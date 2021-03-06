require 'spec_helper'

describe 'FriendlyForwardings' do

  before :each do
    @user = Factory :user
    @user.toggle! :admin
    @user.update_attributes :profile_completion => 5
    @candidate = Factory :candidate
    @recruiter = Factory :recruiter
  end
  
  describe 'should forward' do
    
    describe 'admin users' do
    
      it 'to candidate profile' do
        visit candidate_path @candidate
        fill_in 'email',    :with => @user.email
        fill_in 'password', :with => @user.password
        click_button "#{I18n.t('sessions.new.signin')}"
        current_path.should == candidate_path(@candidate)
      end
    
      it 'to candidates' do
        visit candidates_path
        fill_in 'email',    :with => @user.email
        fill_in 'password', :with => @user.password
        click_button "#{I18n.t('sessions.new.signin')}"
        current_path.should == candidates_path
      end
    
      it 'to recruiter profile' do
        visit recruiter_path @recruiter
        fill_in 'email',    :with => @user.email
        fill_in 'password', :with => @user.password
        click_button "#{I18n.t('sessions.new.signin')}"
        current_path.should == recruiter_path(@recruiter)
      end
    
      it 'to recruiters' do
        visit recruiters_path
        fill_in 'email',    :with => @user.email
        fill_in 'password', :with => @user.password
        click_button "#{I18n.t('sessions.new.signin')}"
        current_path.should == recruiters_path
      end
    end
    
    describe 'candidates' do
      
      before :each do
        @candidate.update_attributes :profile_completion => 0
      end
    
      it 'to recruiter profile' do
        visit recruiter_path @recruiter
        fill_in 'email',    :with => @user.email
        fill_in 'password', :with => @user.password
        click_button "#{I18n.t('sessions.new.signin')}"
        current_path.should == recruiter_path(@recruiter)
      end
  
      it 'to recruiters' do
        visit recruiters_path
        fill_in 'email',    :with => @user.email
        fill_in 'password', :with => @user.password
        click_button "#{I18n.t('sessions.new.signin')}"
        current_path.should == recruiters_path
      end
    end
    
    describe 'recruiters' do
            
      before :each do
        @recruiter.update_attributes :profile_completion => 5
      end
    
      it 'to candidate profile' do
        visit candidate_path @candidate
        fill_in 'email',    :with => @user.email
        fill_in 'password', :with => @user.password
        click_button "#{I18n.t('sessions.new.signin')}"
        current_path.should == candidate_path(@candidate)
      end
  
      it 'to candidates' do
        visit candidates_path
        fill_in 'email',    :with => @user.email
        fill_in 'password', :with => @user.password
        click_button "#{I18n.t('sessions.new.signin')}"
        current_path.should == candidates_path
      end
    end
  end
end