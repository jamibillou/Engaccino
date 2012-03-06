require 'spec_helper'

describe RecruitersController do
  
  render_views
  
  before :each do
    @user      = Factory :user
    @recruiter = Factory :recruiter
    @candidate = Factory :candidate
  end
  
  describe "GET 'index'" do
    
    describe 'for non-signed-in users' do
      
      it "should deny access to 'index'" do
        get :index
        response.should redirect_to signin_path
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe 'for signed-in candidates' do
    
      before :each do
        test_sign_in @candidate
        first_recruiter  = Factory.create :recruiter, :email => Factory.next(:email), :facebook_login => Factory.next(:facebook_login),
                                                      :linkedin_login => Factory.next(:linkedin_login), :twitter_login => Factory.next(:twitter_login)
        second_recruiter = Factory.create :recruiter, :email => Factory.next(:email), :facebook_login => Factory.next(:facebook_login),
                                                      :linkedin_login => Factory.next(:linkedin_login), :twitter_login => Factory.next(:twitter_login)
      end
      
      describe "who haven't completed signup" do
        
        it "should deny access to 'index'" do
          get :index
          response.should redirect_to edit_candidate_path @candidate
          flash[:notice].should == I18n.t('flash.notice.please_finish_signup')
        end
      end
      
      describe 'who have completed signup' do
      
        before :each do
          @candidate.update_attributes :profile_completion => 5
        end
        
        it 'should return http success' do
          get :index
          response.should be_success
        end
        
        it 'should have the right title' do
          get :index
          response.should have_selector 'title', :content => I18n.t('recruiters.index.title')
        end
        
        it 'should have the right selected navigation tab' do
          get :index
          response.should have_selector 'li', :class => 'round selected', :content => I18n.t(:menu_recruiters)
        end
        
        it 'should have a card for each recruiter' do 
          get :index
          Recruiter.all.each do |recruiter|
            response.should have_selector 'div', :id => "recruiter_#{recruiter.id}"
          end  
        end                  
      end
    end
    
    describe 'for signed-in recruiters' do
      
      it "should deny access to 'index'" do
        test_sign_in @recruiter
        get :index
        response.should redirect_to root_path
        flash[:notice].should == I18n.t('flash.notice.candidate_only_page')
      end
    end
    
    describe 'admin features' do
      
      before :each do
        @user.update_attributes :profile_completion => 5
        test_sign_in @user
      end
      
      describe 'for admin users' do
      
        it 'should have a destroy link for each candidate' do 
          @user.toggle! :admin
          get :index            
          Recruiter.all.each do |recruiter|
            response.should have_selector 'a', :id => "destroy_recruiter_#{recruiter.id}"
          end
        end
      end
      
      describe 'for non-admin users' do
      
        it "shouldn't have a destroy link for each candidate" do 
          get :index
          Recruiter.all.each do |recruiter|
            response.should_not have_selector 'a', :id => "destroy_recruiter_#{recruiter.id}"
          end
        end
      end            
    end
  end
  
  describe "GET 'show'" do
    
    describe 'for non-signed-in candidates' do
      
      it "should deny access to 'show'" do
        get :show, :id => @recruiter
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
          get :show,  :id => @recruiter
          response.should redirect_to edit_candidate_path @candidate
          flash[:notice].should == I18n.t('flash.notice.please_finish_signup')
        end
      end
      
      describe 'who have completed signup' do
        
        before :each do
          @candidate.update_attributes :profile_completion => 5
        end
        
        it 'should return http success' do
          get :show, :id => @recruiter
          response.should be_success
        end
        
        it 'should have the right selected navigation tab' do
          get :show, :id => @recruiter
          response.should have_selector 'li', :class => 'round selected', :content => I18n.t(:menu_profile)
        end
      end
    end
  end
  
  describe "GET 'new'" do
  
    describe 'for signed-in recruiters' do
      
      it "should deny access to 'new'" do
        test_sign_in @recruiter
        get :new
        response.should redirect_to recruiter_path @recruiter
        flash[:notice].should == I18n.t('flash.notice.not_a_new_user')
      end
    end
    
    describe 'for non-signed-in recruiters' do
    
      it 'should return http success' do
        get :new
        response.should be_success
      end
      
      it 'should have the right title' do 
        get :new
        response.should have_selector 'title', :content => I18n.t('recruiters.new.title')
      end
    end
  end
  
  describe "POST 'create'" do
          
    describe 'for signed-in recruiters' do
      
      it "should deny access to 'create'" do
        test_sign_in @recruiter
          post :create
          response.should redirect_to recruiter_path @recruiter
          flash[:notice].should == I18n.t('flash.notice.not_a_new_user')
        end
    end
    
    describe 'for non-signed-in recruiters' do
    
      it "should return http success" do
        post :create
        response.should be_success
      end
    
      describe 'success' do
      
        before :each do
          @attr = { :first_name => 'First name',                :last_name             => 'Last name',
                    :password   => 'pouetpouet45',              :password_confirmation => 'pouetpouet45',
                    :email      => 'new_recruiter@example.com', :city                  => 'Sample city',
                    :country    => 'Netherlands' }
        end
        
        it 'should create a recruiter' do
          lambda do
            post :create, :recruiter => @attr
          end.should change(Recruiter, :count).by(1)
        end
        
        it "should render the 'edit' page" do
          post :create, :recruiter => @attr
          response.should render_template :edit
        end
        
        it 'should sign the recruiter in' do
          post :create, :recruiter => @attr
          controller.should be_signed_in
        end
      end
      
      describe 'failure' do
        
        it "should render the 'new' template" do
          post :create, :email => '', :password => '', :password_confirmation => '', :status => ''
          response.should render_template :new
        end
      end
    end  
  end
  
  describe "GET 'edit'" do
  
    describe 'for non-signed-in recruiters' do
      
      it "should deny access to 'edit'" do
        get :edit, :id => @recruiter
        response.should redirect_to signin_path
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe 'for signed-in recruiters' do
      
      before :each do
        test_sign_in @recruiter
      end
    
      describe 'who have completed signup' do
        
        it "should deny access to 'edit'" do
          @recruiter.update_attributes :profile_completion => 5
          get :edit, :id => @recruiter
          response.should redirect_to @recruiter
          flash[:notice].should == I18n.t('flash.notice.already_signed_up')
        end
      end
      
      describe "who haven't completed signup" do
        
        it "should require the matching recruiter" do
          @wrong_recruiter = Factory.create :recruiter, :email => Factory.next(:email), :facebook_login => Factory.next(:facebook_login),
                                                        :linkedin_login => Factory.next(:linkedin_login), :twitter_login => Factory.next(:twitter_login)
          get :edit, :id => @wrong_recruiter
          response.should redirect_to recruiter_path @recruiter
          flash[:notice].should == I18n.t('flash.notice.other_user_page')
        end
        
        it 'should return http success' do
          get :edit, :id => @recruiter
          response.should be_success
        end
      
        it 'should have the right title' do
          get :edit, :id => @recruiter
          response.should have_selector 'title', :content => I18n.t('recruiters.edit.complete_your_profile')
        end
            
        it 'should have an edit form' do
          get :edit, :id => @recruiter
          response.should have_selector 'form', :id => 'recruiter_edit_form'
        end
      end
    end
  end
  
  describe "PUT 'update'" do
          
    describe 'for non-signed-in recruiters' do
      
      it "should deny access to 'update'" do
        put :update, :id => @recruiter
        response.should redirect_to signin_path
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe 'for signed-in recruiters' do
    
      before :each do
        test_sign_in @recruiter
      end
      
      describe 'success' do
      
        before :each do
          @attr = { :recruiter => { :first_name => 'Updated',
                                    :last_name => 'Recruiter',
                                    :company_attributes => { :name => 'BG Corp' } } }
        end
        
        it "should require the matching recruiter" do
          @wrong_recruiter = Factory.create :recruiter, :email => Factory.next(:email), :facebook_login => Factory.next(:facebook_login),
                                                        :linkedin_login => Factory.next(:linkedin_login), :twitter_login => Factory.next(:twitter_login)
          put :update, :recruiter => @attr[:recruiter], :id => @wrong_recruiter
          response.should redirect_to recruiter_path @recruiter
          flash[:notice].should == I18n.t('flash.notice.other_user_page')
        end
        
        it "should update the recruiter's attributes" do
          put :update, :recruiter => @attr[:recruiter], :id => @recruiter
          recruiter = assigns :recruiter
          @recruiter.reload
          @recruiter.first_name == recruiter.first_name
          @recruiter.last_name == recruiter.last_name
          @recruiter.country == recruiter.country
          @recruiter.year_of_birth == recruiter.year_of_birth
          @recruiter.profile_completion >= 0
        end
        
        it 'should not create a recruiter' do
          lambda do
            put :update, :recruiter => @attr[:recruiter], :id => @recruiter
          end.should_not change(Recruiter, :count)
        end
        
        it 'should create a company' do
          lambda do
            put :update, :recruiter => @attr[:recruiter], :id => @recruiter
          end.should change(Company, :count).by(1)
        end
        
        it "should redirect to the 'show' page" do
          put :update, :recruiter => @attr[:recruiter], :id => @recruiter
          response.should redirect_to @recruiter
        end
      end
      
      describe 'failure' do
        
        before :each do
          @attr = { :email => 'new_recruiter@example.com', :first_name => '', :last_name => '', :country => '' }
        end
                    
        it "should render the 'edit' page" do
           put :update, :recruiter => @attr, :id => @recruiter
           response.should render_template :edit
        end
        
        it 'should not create another recruiter' do
          lambda do
            put :update, :recruiter => @attr, :id => @recruiter
          end.should_not change(Recruiter, :count)
        end 
      end
    end
  end
end
