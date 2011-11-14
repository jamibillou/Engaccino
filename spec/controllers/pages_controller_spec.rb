require 'spec_helper'

describe PagesController do

  render_views
  
  before(:each) do
    @base_title = "Engaccino"
  end
  
  describe "GET 'overview'" do
    
    it "returns http success" do
      get :overview
      response.should be_success
    end
    
    it "should have the right title" do
      get :overview
      response.should have_selector("title", :content => "#{@base_title} | Overview")
    end
    
    it "should have the right selected navigation tab" do
      get :overview
      response.should have_selector('li', :class => 'round selected', :content => 'Overview')
    end
    
    it "should have a sign up button" do
      get :overview
      response.should have_selector('a', :class => 'button', :content => 'Sign up')
    end
    
    it "should have a sign in link" do
      get :overview
      response.should have_selector('a', :content => 'Sign in')
    end
    
#    it "should have a search bar" do
#      get :overview
#      response.should have_selector('form', :id => 'search_bar')
#    end
  end

  describe "GET 'walkthrough'" do
    
    it "returns http success" do
      get :walkthrough
      response.should be_success
    end
    
    it "should have the right title" do
      get :walkthrough
      response.should have_selector("title", :content => "#{@base_title} | Walkthrough")
    end
    
    it "should have the right selected navigation tab" do
      get :walkthrough
      response.should have_selector('li', :class => 'round selected', :content => 'Walkthrough')
    end
    
    it "should have a sign up button" do
      get :walkthrough
      response.should have_selector('a', :class => 'button', :content => 'Sign up')
    end
    
    it "should have a sign in link" do
      get :walkthrough
      response.should have_selector('a', :content => 'Sign in')
    end
  end

  describe "GET 'pricing'" do
    
    it "returns http success" do
      get :pricing
      response.should be_success
    end
    
    it "should have the right title" do
      get :pricing
      response.should have_selector("title", :content => "#{@base_title} | Pricing")
    end
    
    it "should have the right selected navigation tab" do
      get :pricing
      response.should have_selector('li', :class => 'round selected', :content => 'Pricing')
    end
    
    it "should have a sign up button" do
      get :pricing
      response.should have_selector('a', :class => 'button', :content => 'Sign up')
    end
    
    it "should have a sign in link" do
      get :pricing
      response.should have_selector('a', :content => 'Sign in')
    end
  end

  describe "GET 'about'" do
    
    it "returns http success" do
      get :about
      response.should be_success
    end
    
    it "should have the right title" do
      get :about
      response.should have_selector("title", :content => "#{@base_title} | About")
    end
    
    it "should have the right selected navigation tab" do
      get :about
      response.should have_selector('li', :class => 'round selected', :content => 'About')
    end
    
    it "should have a sign up button" do
      get :about
      response.should have_selector('a', :class => 'button', :content => 'Sign up')
    end
    
    it "should have a sign in link" do
      get :about
      response.should have_selector('a', :content => 'Sign in')
    end
  end

  describe "GET 'contact'" do
    
    it "returns http success" do
      get :contact
      response.should be_success
    end
    
    it "should have the right title" do
      get :contact
      response.should have_selector("title", :content => "#{@base_title} | Contact")
    end
    
    it "should have the right selected navigation tab" do
      get :contact
      response.should have_selector('li', :class => 'round selected', :content => 'Contact')
    end
    
    it "should have a sign up button" do
      get :contact
      response.should have_selector('a', :class => 'button', :content => 'Sign up')
    end
    
    it "should have a sign in link" do
      get :contact
      response.should have_selector('a', :content => 'Sign in')
    end
  end
end
