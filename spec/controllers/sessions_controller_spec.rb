require 'spec_helper'

describe SessionsController do

  render_views

  describe "GET 'new'" do
    
    it 'should be successful' do
      get :new
      response.should be_success
    end
    
    it 'should have the right title' do
      get :new
      response.body.should have_selector 'title', :text => I18n.t('sessions.new.title')
    end
  end
  
  describe "POST 'create'" do
    
    describe 'failure' do
    
      before :each do
        @attr = { :email => '', :password => '' }
      end
      
      it "should render the 'new' page" do
        post :create, :session => @attr
        response.should render_template 'new'
      end
      
      it 'should have the right title' do
        post :create, :session => @attr
        response.body.should have_selector 'title', :text => I18n.t('sessions.new.title')
      end
      
      it 'should have a flash message' do
        post :create, :session => @attr
        response.body.should have_selector 'div', :class => 'flash error'
      end
    end
    
    describe 'success' do
    
      before :each do
        @candidate = Factory :candidate
        @attr = { :email => @candidate.email, :password => @candidate.password }
      end
      
      it 'should sign the user in' do
        post :create, :session => @attr
        controller.current_user.should == @candidate
        controller.should be_signed_in
      end
      
      it 'should redirect to the User#show page' do
        post :create, :session => @attr
        response.should redirect_to candidate_path @candidate
      end
    end
  end
  
  describe "DELETE 'destroy'" do
    
    it 'should sign the user out' do
      test_sign_in Factory :user
      delete :destroy
      controller.should_not be_signed_in
      response.should redirect_to root_path
    end
  end
end