require 'spec_helper'

describe RecruitersController do
  
  render_views
  
  before :each do
    @recruiter  = Factory :recruiter, :profile_completion => 5
    @recruiter2 = Factory :recruiter, :profile_completion => 5
    @candidate  = Factory :candidate, :profile_completion => 5
    @attr = { :first_name => 'First', :last_name => 'Last', :password => 'pouet45', :password_confirmation => 'pouet45', :email => 'create@example.com', :city => 'Sample city', :country => 'Netherlands' }
  end
  
  describe "GET 'index'" do
        
    before :each do
      test_sign_in @candidate
      get :index
    end
        
    it 'should return http success' do
      response.should be_success
    end
        
    it 'should have the right title' do
      response.body.should have_selector 'title', :text => I18n.t('recruiters.index.title')
    end
        
    it 'should have the right selected navigation tab' do
      response.body.should have_selector 'li', :class => 'round selected', :text => I18n.t(:menu_recruiters)
    end
        
    it 'should have a card for each recruiter' do 
      Recruiter.all.each do |recruiter|
        response.body.should have_selector 'div', :id => "recruiter_#{recruiter.id}"
      end
    end
      
    it "shouldn't have a destroy link for each recruiter" do 
      Recruiter.all.each do |recruiter|
        response.body.should_not include "destroy_recruiter_#{recruiter.id}"
      end
    end
  end
  
  describe "GET 'show'" do
        
    before  :each do
      test_sign_in @candidate
      get :show, :id => @recruiter
    end
        
    it 'should return http success' do
      response.should be_success
    end
        
    it 'should have the right selected navigation tab' do
      response.body.should have_selector 'li', :class => 'round selected', :text => I18n.t(:menu_recruiters)
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
      response.body.should have_selector 'title', :text => I18n.t('recruiters.new.title')
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
          post :create, :recruiter => @attr
        end.should change(Recruiter, :count).by 1
      end
        
      it "should render the 'edit' page" do
        response.should render_template :edit
      end
        
      it 'should sign the recruiter in' do
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
      @recruiter.update_attributes :profile_completion => 0
      test_sign_in @recruiter
      get :edit, :id => @recruiter
    end
        
    it 'should return http success' do
      response.should be_success
    end
      
    it 'should have the right title' do
      response.body.should have_selector 'title', :text => I18n.t('recruiters.edit.complete_your_profile')
    end
            
    it 'should have an edit form' do
      response.body.should have_selector 'form', :id => 'recruiter_edit_form'
    end
  end
  
  describe "PUT 'update'" do
    
    before :each do
      test_sign_in @recruiter
      @updated_attr =  @attr.merge(:first_name => 'Updated', :last_name => 'Updated', :company_attributes => { :name => 'BG Corp'})
    end
      
    describe 'success' do
        
      it 'should update the recruiter' do
        put :update, :recruiter => @updated_attr, :id => @recruiter
        updated_recruiter = assigns :recruiter
        @recruiter.reload
        @recruiter.first_name.should    == updated_recruiter.first_name
        @recruiter.last_name.should     == updated_recruiter.last_name
        @recruiter.company.name.should  == updated_recruiter.company.name
      end
        
      it 'should not create a new recruiter' do
        lambda do
          put :update, :recruiter => @updated_attr, :id => @recruiter
        end.should_not change(Recruiter, :count)
      end
        
      it 'should create a company' do
        lambda do
          put :update, :recruiter => @updated_attr, :id => @recruiter
        end.should change(Company, :count).by 1
      end
        
      it "should redirect to the 'show' page" do
        put :update, :recruiter => @updated_attr, :id => @recruiter
        response.should redirect_to @recruiter
      end
    end
      
    describe 'failure' do
                    
      it "should render the 'edit' page" do
        put :update, :recruiter => @attr.merge(:email => 'new_recruiter@example.com', :first_name => '', :last_name => '', :country => ''), :id => @recruiter
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
    
    describe 'for signed-in recruiter' do
    
      before :each do
        @recruiter.toggle! :admin
        test_sign_in @recruiter
      end
        
      it 'should destroy the recruiter' do
        lambda do
          delete :destroy, :id => @recruiter
        end.should change(Recruiter, :count).by -1
      end
    end
  end
end
