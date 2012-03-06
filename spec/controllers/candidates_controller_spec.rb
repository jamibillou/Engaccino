require 'spec_helper'

describe CandidatesController do

  render_views

  before :each do
    @candidate = Factory :candidate
    @recruiter = Factory :recruiter
  end
  
  describe "GET 'index'" do
    
    describe 'for non-signed-in users' do
      
      it "should deny access to 'index'" do
        get :index
        response.should redirect_to signin_path
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe 'for signed-in recruiters' do
    
      before :each do
        test_sign_in @recruiter
        first_candidate  = Factory.create :candidate, :email => Factory.next(:email), :facebook_login => Factory.next(:facebook_login),
                                                      :linkedin_login => Factory.next(:linkedin_login), :twitter_login => Factory.next(:twitter_login)
        second_candidate = Factory.create :candidate, :email => Factory.next(:email), :facebook_login => Factory.next(:facebook_login),
                                                      :linkedin_login => Factory.next(:linkedin_login), :twitter_login => Factory.next(:twitter_login)
      end
      
      describe "who haven't completed signup" do
        
        it "should deny access to 'index'" do
          get :index
          response.should redirect_to edit_recruiter_path @recruiter
          flash[:notice].should == I18n.t('flash.notice.please_finish_signup')
        end
      end
      
      describe 'who have completed signup' do
      
        before :each do
          @recruiter.update_attributes :profile_completion => 5
        end
        
        it 'should return http success' do
          get :index
          response.should be_success
        end
        
        it 'should have the right title' do
          get :index
          response.should have_selector 'title', :content => I18n.t('candidates.index.title')
        end
        
        it 'should have the right selected navigation tab' do
          get :index
          response.should have_selector'li', :class => 'round selected', :content => I18n.t(:menu_candidates)
        end
        
        it 'should have a card for each candidate' do 
          get :index
          Candidate.all.each do |candidate|
            response.should have_selector 'div', :id => "candidate_#{candidate.id}"
          end  
        end
        
        describe 'for admin candidates' do
          
          before :each do
            @recruiter.toggle! :admin
          end
          
          it 'should have a destroy link for each candidate' do 
            get :index            
            Candidate.all.each do |candidate|
              response.should have_selector 'a', :id => "destroy_candidate_#{candidate.id}"
            end
          end            
        end
        
        describe 'for non-admin candidates' do
          it "shouldn't have a destroy link for each candidate" do 
            get :index
            Candidate.all.each do |candidate|
              response.should_not have_selector 'a', :id => "destroy_candidate_#{candidate.id}"
            end
          end  
        end                        
      end
    end
  end
  
  describe "GET 'show'" do
    
    describe 'for non-signed-in recruiters' do
      
      it "should deny access to 'show'" do
        get :show, :id => @candidate
        response.should redirect_to signin_path
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe 'for signed-in recruiters' do
    
      before  :each do
        test_sign_in @recruiter
      end
      
      describe "who haven't completed signup" do
        
        it "should deny access to 'show'" do
          get :show,  :id => @candidate
          response.should redirect_to edit_recruiter_path @recruiter
          flash[:notice].should == I18n.t('flash.notice.please_finish_signup')
        end
      end
      
      describe 'who have completed signup' do
        
        before :each do
          @recruiter.update_attributes :profile_completion => 5
        end
        
        it 'should return http success' do
          get :show, :id => @candidate
          response.should be_success
        end
        
        it 'should have the right selected navigation tab' do
          get :show, :id => @candidate
          response.should have_selector 'li', :class => 'round selected', :content => I18n.t(:menu_profile)
        end
      end
    end
  end

  describe "GET 'new'" do
  
    describe 'for signed-in candidates' do
      
      it "should deny access to 'new'" do
        test_sign_in @candidate
        get :new
        response.should redirect_to candidate_path @candidate
        flash[:notice].should == I18n.t('flash.notice.not_a_new_user')
      end
    end
    
    describe 'for non-signed-in candidates' do
    
      it 'should return http success' do
        get :new
        response.should be_success
      end
      
      it 'should have the right title' do 
        get :new
        response.should have_selector 'title', :content => I18n.t('candidates.new.title')
      end
    end
  end

  describe "POST 'create'" do
          
    describe 'for signed-in candidates' do
      
      it "should deny access to 'create'" do
        test_sign_in @candidate
        post :create
        response.should redirect_to candidate_path @candidate
        flash[:notice].should == I18n.t('flash.notice.not_a_new_user')
      end
    end
    
    describe 'for non-signed-in candidates' do
    
      it "should return http success" do
        post :create
        response.should be_success
      end
    
      describe 'success' do
      
        before :each do
          @attr = { :first_name => 'First name',                :last_name             => 'Last name',
                    :password   => 'pouetpouet45',              :password_confirmation => 'pouetpouet45',
                    :email      => 'new_candidate@example.com', :status                => 'available',
                    :city       => 'Sample city',               :country               => 'Netherlands' }
        end
        
        it 'should create a candidate' do
          lambda do
            post :create, :candidate => @attr
          end.should change(Candidate, :count).by(1)
        end
        
        it "should render the 'edit' page" do
          post :create, :candidate => @attr
          response.should render_template :edit
        end
        
        it 'should sign the candidate in' do
          post :create, :candidate => @attr
          controller.should be_signed_in
        end
      end
      
      describe 'failure' do
        
        it "should render the 'new' template" do
          post :create, :email => '', :password => '', :password_confirmation => '', :status => ''
          response.should render_template :new
        end
        
        it 'should have a flash message' do
          post :create, :email => '', :password => '', :password_confirmation => '', :status => ''
          response.should have_selector 'div', :class => 'flash error'
        end
      end
    end  
  end
  
  describe "GET 'edit'" do
  
    describe 'for non-signed-in candidates' do
      
      it "should deny access to 'edit'" do
        get :edit, :id => @candidate
        response.should redirect_to signin_path
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe 'for signed-in candidates' do
      
      before :each do
        test_sign_in @candidate
      end
    
      describe 'who have completed signup' do
        
        it "should deny access to 'edit'" do
          @candidate.update_attributes :profile_completion => 5
          get :edit, :id => @candidate
          response.should redirect_to @candidate
          flash[:notice].should == I18n.t('flash.notice.already_signed_up')
        end
      end
      
      describe "who haven't completed signup" do
        
        it "should require the matching candidate" do
          @wrong_candidate = Factory.create :candidate, :email => Factory.next(:email), :facebook_login => Factory.next(:facebook_login),
                                                        :linkedin_login => Factory.next(:linkedin_login), :twitter_login => Factory.next(:twitter_login)
          get :edit, :id => @wrong_candidate
          response.should redirect_to candidate_path @candidate
          flash[:notice].should == I18n.t('flash.notice.other_user_page')
        end
        
        it 'should return http success' do
          get :edit, :id => @candidate
          response.should be_success
        end
      
        it 'should have the right title' do
          get :edit, :id => @candidate
          response.should have_selector 'title', :content => I18n.t('candidates.edit.complete_your_profile')
        end
            
        it 'should have an edit form' do
          get :edit, :id => @candidate
          response.should have_selector 'form', :id => 'candidate_edit_form'
        end
      end
    end
  end
  
  describe "PUT 'update'" do
          
    describe 'for non-signed-in candidates' do
      
      it "should deny access to 'update'" do
        put :update, :id => @candidate
        response.should redirect_to signin_path
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe 'for signed-in candidates' do
    
      before :each do
        test_sign_in @candidate
      end
      
      describe 'success' do
      
        before :each do
          @attr = { :candidate => { :first_name => 'Updated',
                                    :last_name => 'Candidate',
                                    :experiences_attributes => { '0' => { :role => 'BG en chef',
                                                                          :start_month => 7,
                                                                          :start_year => 1984,
                                                                          :end_month => 12,
                                                                          :end_year => 2011,
                                                                          :company_attributes => { :name => 'BG Corp' } } } }  }
        end
        
        it "should require the matching candidate" do
          @wrong_candidate = Factory.create :candidate, :email => Factory.next(:email), :facebook_login => Factory.next(:facebook_login),
                                                        :linkedin_login => Factory.next(:linkedin_login), :twitter_login => Factory.next(:twitter_login)
          put :update, :candidate => @attr[:candidate], :id => @wrong_candidate
          response.should redirect_to candidate_path @candidate
          flash[:notice].should == I18n.t('flash.notice.other_user_page')
        end
        
        it "should update the candidate's attributes" do
          put :update, :candidate => @attr[:candidate], :id => @candidate
          candidate = assigns :candidate
          @candidate.reload
          @candidate.first_name == candidate.first_name
          @candidate.last_name == candidate.last_name
          @candidate.country == candidate.country
          @candidate.year_of_birth == candidate.year_of_birth
          @candidate.profile_completion >= 0
        end
        
        it 'should not create a candidate' do
          lambda do
            put :update, :candidate => @attr[:candidate], :id => @candidate
          end.should_not change(Candidate, :count)
        end
        
        it 'should create an experience' do
          lambda do
            put :update, :candidate => @attr[:candidate], :id => @candidate
          end.should change(Experience, :count).by(1)
        end
        
        it 'should create a company' do
          lambda do
            put :update, :candidate => @attr[:candidate], :id => @candidate
          end.should change(Company, :count).by(1)
        end
        
        it "should redirect to the 'show' page" do
          put :update, :candidate => @attr[:candidate], :id => @candidate
          response.should redirect_to @candidate
        end
      end
      
      describe 'failure' do
        
        before :each do
          @attr = { :email => 'new_candidate@example.com', :first_name => '', :last_name => '', :country => '' }
        end
                    
        it "should render the 'edit' page" do
           put :update, :candidate => @attr, :id => @candidate
           response.should render_template :edit
        end
        
        it 'should not create another candidate' do
          lambda do
            put :update, :candidate => @attr, :id => @candidate
          end.should_not change(Candidate, :count)
        end 
      end
    end
  end

  describe "DELETE 'destroy'" do
    
    describe 'for non-signed-in candidates' do
      
      it "should deny access to 'update'" do
        delete :destroy, :id => @candidate
        response.should redirect_to signin_path
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe 'for signed-in candidates' do
    
      before :each do
        test_sign_in @candidate
      end
      
      describe "who haven't got admin rights" do
      
        it 'should not destroy the candidate' do
          lambda do
            delete :destroy, :id => @candidate
          end.should_not change(Candidate, :count).by(-1)
        end
        
        it 'should redirect to the root path' do
          delete :destroy, :id => @candidate
          flash[:notice].should == I18n.t('flash.notice.restricted_page')
          response.should redirect_to candidate_path @candidate
        end
      end
      
      describe 'who have admin rights' do
      
        before :each do
          @candidate.toggle! :admin
        end
        
        it 'should destroy the candidate' do
          lambda do
            delete :destroy, :id => @candidate
          end.should change(Candidate, :count).by(-1)
        end
        
        it 'should redirect to the candidates page' do
          delete :destroy, :id => @candidate
          flash[:success].should == I18n.t('flash.success.candidate_destroyed')
          response.should redirect_to candidates_path
        end
      end
    end
  end
end
