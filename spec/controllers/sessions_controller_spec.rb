require 'spec_helper'

describe SessionsController do

  render_views
  
  before :each do
    @candidate = Factory :candidate
    @attr = { :email => @candidate.email, :password => @candidate.password }
  end

  describe "GET 'new'" do
    
    before :each do
      get :new
    end
    
    it 'should return http success' do
      response.should be_success
    end
    
    it 'should have the right title' do
      response.body.should have_selector 'title', :text => I18n.t('sessions.new.title')
    end
  end
  
  describe "POST 'create'" do
    
    describe 'failure' do
    
      before :each do
        post :create, :session => @attr.merge(:email => '', :password => '')
      end
      
      it "should render the 'new' page" do
        response.should render_template 'new'
      end
      
      it 'should have the right title' do
        response.body.should have_selector 'title', :text => I18n.t('sessions.new.title')
      end
      
      it 'should have a flash message' do
        response.body.should have_selector 'div', :class => 'flash error'
      end
    end
    
    describe 'success' do
      
      before :each do
        post :create, :session => @attr
      end
      
      it 'should sign the candidate in' do
        controller.current_user.should == @candidate
        controller.should be_signed_in
      end
      
      it 'should redirect to root_path' do
        response.should redirect_to root_path
      end
    end
  end
  
  describe "DELETE 'destroy'" do
    
    before :each do
      test_sign_in Factory :user
      delete :destroy
    end
    
    it 'should sign the user out' do
      controller.should_not be_signed_in
    end
    
    it 'should redirect to root_path' do
      response.should redirect_to root_path
    end
  end
end