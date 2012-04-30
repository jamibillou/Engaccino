require 'spec_helper'

describe CandidatesController do

  render_views

  before :each do
    @candidate  = Factory :candidate, :profile_completion => 5
    @candidate2 = Factory :candidate, :profile_completion => 5
    @recruiter  = Factory :recruiter, :profile_completion => 5
    @attr = { :first_name => 'First', :last_name => 'Last', :password => 'pouet45', :password_confirmation => 'pouet45', :email => 'create@example.com', :status => 'available', :city => 'City', :country => 'Netherlands' }
  end
  
  describe "GET 'index'" do
        
    before :each do
      test_sign_in @recruiter
      get :index
    end
        
    it 'should return http success' do
      response.should be_success
    end
        
    it 'should have the right title' do
      response.body.should have_selector 'title', :text => I18n.t('candidates.index.title')
    end
        
    it 'should have the right selected navigation tab' do
      response.body.should have_selector 'li', :class => 'round selected', :text => I18n.t(:menu_candidates)
    end
        
    it 'should have a card for each candidate' do 
      Candidate.all.each do |candidate|
        response.body.should have_selector 'div', :id => "candidate_#{candidate.id}"
      end
    end
      
    it "shouldn't have a destroy link for each candidate" do 
      Candidate.all.each do |candidate|
        response.body.should_not include "destroy_candidate_#{candidate.id}"
      end
    end
  end
  
  describe "GET 'show'" do
        
    before  :each do
      test_sign_in @recruiter
      get :show, :id => @candidate
    end
        
    it 'should return http success' do
      response.should be_success
    end
        
    it 'should have the right selected navigation tab' do
      response.body.should have_selector 'li', :class => 'round selected', :text => I18n.t(:menu_candidates)
    end
  end

  describe "GET 'new'" do
        
    before :each do
      get :new
    end
    
    it 'should return http success' do
      response.should be_success
    end
      
    it 'should have the right title' do 
      response.body.should have_selector 'title', :text => I18n.t('candidates.new.title')
    end
  end

  describe "POST 'create'" do
    
    it "should return http success" do
      post :create
      response.should be_success
    end
    
    describe 'success' do
      
      before :each do
        lambda do
          post :create, :candidate => @attr
        end.should change(Candidate, :count).by 1
      end
        
      it "should render the 'edit' page" do
        response.should render_template :edit
      end
        
      it 'should sign the candidate in' do
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
  
  describe "GET 'edit'" do
      
    before :each do
      @candidate.update_attributes :profile_completion => 0
      test_sign_in @candidate
      get :edit, :id => @candidate
    end
        
    it 'should return http success' do
      response.should be_success
    end
      
    it 'should have the right title' do
      response.body.should have_selector 'title', :text => I18n.t('candidates.edit.complete_your_profile')
    end
            
    it 'should have an edit form' do
      response.body.should have_selector 'form', :id => 'candidate_edit_form'
    end
  end
  
  describe "PUT 'update'" do
        
    before :each do
      test_sign_in @candidate
    end
      
    describe 'success' do
      
      before :each do
        @updated_attr = @attr.merge( :first_name => 'Updated',
                                     :experiences_attributes => { '0' => { :role => 'BG en chef', :start_month => 7, :start_year => 1984, :end_month => 12, :end_year => 2011,
                                     :company_attributes => { :name => 'BG Corp', :city => 'Rotterdam', :country => 'Netherlands' } } } )
      end
        
      it 'should update the candidate' do
        put :update, :candidate => @updated_attr, :id => @candidate
        updated_candidate = assigns :candidate
        @candidate.reload
        @candidate.first_name.should == updated_candidate.first_name
      end
        
      it 'should not create a new candidate' do
        lambda do
          put :update, :candidate => @updated_attr, :id => @candidate
        end.should_not change(Candidate, :count)
      end
        
      it 'should create an experience and a company' do
        lambda do
          put :update, :candidate => @updated_attr, :id => @candidate
        end.should change(Experience, :count).by(1) && change(Company, :count).by(1)
      end
        
      it "should redirect to the 'show' page" do
        put :update, :candidate => @updated_attr, :id => @candidate
        response.should redirect_to @candidate
      end
    end
      
    describe 'failure' do
                    
      it "should render the 'edit' page" do
        put :update, :candidate => @attr.merge(:email => 'new_candidate@example.com', :first_name => '', :last_name => '', :country => ''), :id => @candidate
        response.should render_template :edit
      end
    end
  end

  describe "DELETE 'destroy'" do
    
    describe 'for non-signed-in users' do
      
      it "should deny access to 'destroy'" do
        delete :destroy, :id => @candidate
        response.should redirect_to signin_path
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe 'for signed-in candidates' do
    
      before :each do
        @candidate.toggle! :admin
        test_sign_in @candidate
      end
        
      it 'should destroy the candidate' do
        lambda do
          delete :destroy, :id => @candidate
        end.should change(Candidate, :count).by -1
      end
    end
  end
end
