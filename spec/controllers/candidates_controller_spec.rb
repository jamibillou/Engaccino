require 'spec_helper'

describe CandidatesController do

  render_views

  before(:each) do
    @candidate = Factory(:candidate)
  end

  describe "GET 'show'" do
    
    describe "for non-signed-in candidates" do
      
      it "should deny access to 'show'" do
        get :show, :id => @candidate
        response.should redirect_to(signin_path)
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe "for signed-in candidates" do
    
      before (:each) do
        test_sign_in(@candidate)
      end
      
      describe "who haven't completed signup" do
        
        it "should deny access to 'show'" do
          get :show,  :id => @candidate
          response.should redirect_to(edit_candidate_path(@candidate))
          flash[:notice].should == I18n.t('flash.notice.please_finish_signup')
        end
      end
      
      describe "who have completed signup" do
        
        before(:each) do
          @candidate.update_attributes(:profile_completion => 10)
        end
        
        it "should return http success" do
          get :show, :id => @candidate
          response.should be_success
        end
        
        it "should have the right selected navigation tab" do
          get :show, :id => @candidate
          response.should have_selector('li', :class => 'round selected', :content => I18n.t(:menu_profile))
        end
      end
    end
  end

  describe "GET 'new'" do
  
    describe "for signed-in users" do
      
      it "should deny access to 'new'" do
        test_sign_in(@candidate)
        get :new
        response.should redirect_to(candidate_path(@candidate))
        flash[:notice].should == I18n.t('flash.notice.already_registered')
      end
    end
    
    describe "for non-signed-in users" do
    
      it "should return http success" do
        get :new
        response.should be_success
      end
      
      it "should have the right title" do 
        get :new
        response.should have_selector('title', :content => I18n.t('candidates.new.title'))
      end
    end
  end

end
