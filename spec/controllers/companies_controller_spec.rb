require 'spec_helper'

describe CompaniesController do
  
  before :each do
    @company   = Factory :company
    @user      = Factory :user
    @recruiter = Factory :recruiter
    @candidate = Factory :candidate
  end
  
  describe "GET 'show'" do
      
    describe 'for candidates' do
        
      before :each do
        test_sign_in @candidate
        @candidate.update_attributes :profile_completion => 5
      end
        
      it 'should return http success' do
        get :show, :id => @company
        response.should be_success
      end
        
      # it 'should have the right selected navigation tab' do
      #   get :show, :id => @company
      #   response.should have_selector 'li', :class => 'round selected', :content => I18n.t(:menu_recruiters)
      # end
    end
    
    describe 'for recruiters' do

      it "should deny access to 'show'" do
        test_sign_in @recruiter
        @recruiter.update_attributes :profile_completion => 5
        get :show, :id => @company
        response.should redirect_to recruiter_path @recruiter
        flash[:notice].should == I18n.t('flash.notice.restricted_page')
      end
    end
  end
end
