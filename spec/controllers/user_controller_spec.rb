require 'spec_helper'

describe UserController do

  render_views

  before(:each) do
    @user = Factory(:user)
  end

  describe "GET 'index'" do
    it "returns http success" do
      get :index
      response.should be_success
    end
  end

  describe "GET 'show'" do
    
    it "returns http success" do
      get :show, :id => @user
      response.should be_success
    end
  end

  describe "GET 'new'" do
  
    it "returns http success" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do 
      get :new
      response.should have_selector('title', :content => I18n.t('user.new.title'))
    end
  end

  describe "POST 'create'" do
  
    it "returns http success" do
      post :create
      response.should be_success
    end
  end

  describe "GET 'edit'" do
  
    it "returns http success" do
      get :edit, :id => @user
      response.should be_success
    end
  end

  describe "PUT 'update'" do
  
    it "returns http success" do
      put :update, :id => @user
      response.should be_success
    end
  end

  describe "DELETE 'destroy'" do
    
    it "returns http success" do
      delete :destroy, :id => @user
      response.should be_success
    end
  end
end
