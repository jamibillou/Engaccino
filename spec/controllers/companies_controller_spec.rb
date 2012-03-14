require 'spec_helper'

describe CompaniesController do
  
  before :each do
    @company   = Factory :company
    @user      = Factory :user
    @recruiter = Factory :recruiter
    @candidate = Factory :candidate
  end
  
  describe "GET 'show'" do
    
    describe 'for non-signed-in candidates' do
      
      it "should deny access to 'show'" do
        get :show, :id => @company
        response.should redirect_to signin_path
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe 'for signed-in candidates' do
    
      before  :each do
        test_sign_in @candidate
      end
      
      describe "who haven't completed signup" do
        
        it "should deny access to 'show'" do
          get :show,  :id => @company
          response.should redirect_to edit_candidate_path @candidate
          flash[:notice].should == I18n.t('flash.notice.please_finish_signup')
        end
      end
      
      describe 'who have completed signup' do
        
        before :each do
          @candidate.update_attributes :profile_completion => 5
        end
        
        it 'should return http success' do
          get :show, :id => @company
          response.should be_success
        end
        
        it 'should have the right selected navigation tab' # do
        #           get :show, :id => @company
        #           response.should have_selector 'li', :class => 'round selected', :content => I18n.t(:menu_recruiters)
        #         end
      end
    end
    
    describe 'for signed-in recruiters' do
    
      before  :each do
        test_sign_in @recruiter
      end
        
      it "should deny access to 'show'" do
        get :show, :id => @company
        response.should redirect_to recruiter_path @recruiter
        flash[:notice].should == I18n.t('flash.notice.restricted_page')
        @recruiter.update_attributes :profile_completion => 5
        get :show, :id => @company
        response.should redirect_to recruiter_path @recruiter
        flash[:notice].should == I18n.t('flash.notice.restricted_page')
      end
    end
  end
end
