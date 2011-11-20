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
      response.should have_selector("title", :content => "#{@base_title} | #{I18n.t(:menu_overview)}")
    end
    
    it "should have the right selected navigation tab" do
      get :overview
      response.should have_selector('li', :class => 'round selected', :content => I18n.t(:menu_overview))
    end
    
    it "should have a sign up button" do
      get :overview
      response.should have_selector('a', :class => 'button', :content => I18n.t(:sign_up))
    end
    
    it "should have a sign in link" do
      get :overview
      response.should have_selector('a', :content => I18n.t(:sign_in))
    end
    
    it "should have a search bar" do
      get :overview
      response.should have_selector('form', :id => 'search_bar')
    end
  end

  describe "GET 'walkthrough'" do
    
    it "returns http success" do
      get :walkthrough
      response.should be_success
    end
    
    it "should have the right title" do
      get :walkthrough
      response.should have_selector("title", :content => "#{@base_title} | #{I18n.t(:menu_walkthrough)}")
    end
    
    it "should have the right selected navigation tab" do
      get :walkthrough
      response.should have_selector('li', :class => 'round selected', :content => I18n.t(:menu_walkthrough))
    end
    
    it "should have a sign up button" do
      get :walkthrough
      response.should have_selector('a', :class => 'button', :content => I18n.t(:sign_up))
    end
    
    it "should have a sign in link" do
      get :walkthrough
      response.should have_selector('a', :content => I18n.t(:sign_in))
    end
    
    it "should have a search bar" do
      get :walkthrough
      response.should have_selector('form', :id => 'search_bar')
    end
  end

  describe "GET 'pricing'" do
    
    it "returns http success" do
      get :pricing
      response.should be_success
    end
    
    it "should have the right title" do
      get :pricing
      response.should have_selector("title", :content => "#{@base_title} | #{I18n.t(:menu_pricing)}")
    end
    
    it "should have the right selected navigation tab" do
      get :pricing
      response.should have_selector('li', :class => 'round selected', :content => I18n.t(:menu_pricing))
    end
    
    it "should have a sign up button" do
      get :pricing
      response.should have_selector('a', :class => 'button', :content => I18n.t(:sign_up))
    end
    
    it "should have a sign in link" do
      get :pricing
      response.should have_selector('a', :content => I18n.t(:sign_in))
    end
    
    it "should have a search bar" do
      get :pricing
      response.should have_selector('form', :id => 'search_bar')
    end
  end

  describe "GET 'about'" do
    
    it "returns http success" do
      get :about
      response.should be_success
    end
    
    it "should have the right title" do
      get :about
      response.should have_selector("title", :content => "#{@base_title} | #{I18n.t(:menu_about)}")
    end
    
    it "should have the right selected navigation tab" do
      get :about
      response.should have_selector('li', :class => 'round selected', :content => I18n.t(:menu_about))
    end
    
    it "should have a sign up button" do
      get :about
      response.should have_selector('a', :class => 'button', :content => I18n.t(:sign_up))
    end
    
    it "should have a sign in link" do
      get :about
      response.should have_selector('a', :content => I18n.t(:sign_in))
    end
    
    it "should have a search bar" do
      get :about
      response.should have_selector('form', :id => 'search_bar')
    end
  end

  describe "GET 'contact'" do
    
    it "returns http success" do
      get :contact
      response.should be_success
    end
    
    it "should have the right title" do
      get :contact
      response.should have_selector("title", :content => "#{@base_title} | #{I18n.t(:menu_contact)}")
    end
    
    it "should have the right selected navigation tab" do
      get :contact
      response.should have_selector('li', :class => 'round selected', :content => I18n.t(:menu_contact))
    end
    
    it "should have a sign up button" do
      get :contact
      response.should have_selector('a', :class => 'button', :content => I18n.t(:sign_up))
    end
    
    it "should have a sign in link" do
      get :contact
      response.should have_selector('a', :content => I18n.t(:sign_in))
    end
    
    it "should have a search bar" do
      get :contact
      response.should have_selector('form', :id => 'search_bar')
    end
  end
end
