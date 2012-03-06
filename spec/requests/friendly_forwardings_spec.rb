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
        fill_in :email,    :with => @user.email
        fill_in :password, :with => @user.password
        click_button
        response.should render_template 'candidates/show'
      end
    
      it 'to candidates' do
        visit candidates_path
        fill_in :email,    :with => @user.email
        fill_in :password, :with => @user.password
        click_button
        response.should render_template 'candidates/index'
      end
    
      it 'to recruiter profile' do
        visit recruiter_path @recruiter
        fill_in :email,    :with => @user.email
        fill_in :password, :with => @user.password
        click_button
        response.should render_template 'recruiters/show'
      end
    
      it 'to recruiters' do
        visit recruiters_path
        fill_in :email,    :with => @user.email
        fill_in :password, :with => @user.password
        click_button
        response.should render_template 'recruiters/index'
      end
    end
    
    describe 'candidates' do
      
      describe 'who have completed signup' do
      
        before :each do
          @candidate.update_attributes :profile_completion => 5
        end
      
        it 'to recruiter profile' do
          visit recruiter_path @recruiter
          fill_in :email,    :with => @candidate.email
          fill_in :password, :with => @candidate.password
          click_button
          response.should render_template 'recruiters/show'
        end
    
        it 'to recruiters' do
          visit recruiters_path
          fill_in :email,    :with => @candidate.email
          fill_in :password, :with => @candidate.password
          click_button
          response.should render_template 'recruiters/index'
        end
      end
    end
    
    describe 'recruiters' do
      
      describe 'who have completed signup' do
      
        before :each do
          @recruiter.update_attributes :profile_completion => 5
        end
      
        it 'to candidate profile' do
          visit candidate_path @candidate
          fill_in :email,    :with => @recruiter.email
          fill_in :password, :with => @recruiter.password
          click_button
          response.should render_template 'candidates/show'
        end
    
        it 'to candidates' do
          visit candidates_path
          fill_in :email,    :with => @recruiter.email
          fill_in :password, :with => @recruiter.password
          click_button
          response.should render_template 'candidates/index'
        end
      end
    end
  end
  
  describe "shouldn't forward" do
    
    describe 'candidates' do
      
      describe "who haven't completed signup" do
      
        it 'to recruiter profile' do
          visit recruiter_path @recruiter
          fill_in :email,    :with => @candidate.email
          fill_in :password, :with => @candidate.password
          click_button
          response.should_not render_template 'recruiters/show'
        end
    
        it 'to recruiters' do
          visit recruiters_path
          fill_in :email,    :with => @candidate.email
          fill_in :password, :with => @candidate.password
          click_button
          response.should_not render_template 'recruiters/index'
        end
      end
    end
    
    describe 'recruiters' do
      
      describe "who haven't completed signup" do
      
        it 'to candidate profile' do
          visit candidate_path @candidate
          fill_in :email,    :with => @recruiter.email
          fill_in :password, :with => @recruiter.password
          click_button
          response.should_not render_template 'candidates/show'
        end
    
        it 'to candidates' do
          visit candidates_path
          fill_in :email,    :with => @recruiter.email
          fill_in :password, :with => @recruiter.password
          click_button
          response.should_not render_template 'candidates/index'
        end
      end
    end
  end
end