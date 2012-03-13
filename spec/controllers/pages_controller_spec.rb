require 'spec_helper'

describe PagesController do

  render_views
  
  before :each do
    @base_title = 'Engaccino'
  end
  
  describe "GET 'overview'" do
        
    it 'should return http success' do
      get :overview
      response.should be_success
    end
    
    it 'should have the right title' do
      get :overview
      response.body.should have_selector 'title', :text => "#{@base_title} | #{I18n.t(:menu_overview)}"
    end
    
    it 'should have the right selected navigation tab' do
      get :overview
      response.body.should have_selector 'li', :class => 'round selected', :text => I18n.t(:menu_overview)
    end
    
    it 'should have a candidate sign up button' do
      get :overview
      response.body.should have_selector 'a', :text => I18n.t(:candidate_sign_up)
    end
    
    it 'should have a recruiter sign up button' do
      get :overview
      response.body.should have_selector 'a', :text => I18n.t(:recruiter_sign_up)
    end
    
    it 'should have a sign in link' do
      get :overview
      response.body.should have_selector 'a', :text => I18n.t(:sign_in)
    end
    
    it 'should have a search bar' do
      get :overview
      response.body.should have_selector 'form', :id => 'search_bar_form'
    end
  end

  describe "GET 'tour'" do
    
    it 'should return http success' do
      get :tour
      response.should be_success
    end
    
    it 'should have the right title' do
      get :tour
      response.body.should have_selector 'title', :text => "#{@base_title} | #{I18n.t(:menu_tour)}"
    end
    
    it 'should have the right selected navigation tab' do
      get :tour
      response.body.should have_selector 'li', :class => 'round selected', :text => I18n.t(:menu_tour)
    end
    
    it 'should have a candidate sign up button' do
      get :overview
      response.body.should have_selector 'a', :text => I18n.t(:candidate_sign_up)
    end
    
    it 'should have a recruiter sign up button' do
      get :overview
      response.body.should have_selector 'a', :text => I18n.t(:recruiter_sign_up)
    end
    
    it 'should have a sign in link' do
      get :tour
      response.body.should have_selector 'a', :text => I18n.t(:sign_in)
    end
    
    it 'should have a search bar' do
      get :tour
      response.body.should have_selector 'form', :id => 'search_bar_form'
    end
  end

  describe "GET 'pricing'" do
    
    it 'should return http success' do
      get :pricing
      response.should be_success
    end
    
    it 'should have the right title' do
      get :pricing
      response.body.should have_selector 'title', :text => "#{@base_title} | #{I18n.t(:menu_pricing)}"
    end
    
    it 'should have the right selected navigation tab' do
      get :pricing
      response.body.should have_selector 'li', :class => 'round selected', :text => I18n.t(:menu_pricing)
    end
    
    it 'should have a candidate sign up button' do
      get :overview
      response.body.should have_selector 'a', :text => I18n.t(:candidate_sign_up)
    end
    
    it 'should have a recruiter sign up button' do
      get :overview
      response.body.should have_selector 'a', :text => I18n.t(:recruiter_sign_up)
    end
    
    it 'should have a sign in link' do
      get :pricing
      response.body.should have_selector 'a', :text => I18n.t(:sign_in)
    end
    
    it 'should have a search bar' do
      get :pricing
      response.body.should have_selector 'form', :id => 'search_bar_form'
    end
  end

  describe "GET 'about'" do
    
    it 'should return http success' do
      get :about
      response.should be_success
    end
    
    it 'should have the right title' do
      get :about
      response.body.should have_selector 'title', :text => "#{@base_title} | #{I18n.t(:menu_about)}"
    end
    
    it 'should have the right selected navigation tab' do
      get :about
      response.body.should have_selector 'li', :class => 'round selected', :text => I18n.t(:menu_about)
    end
    
    it 'should have a candidate sign up button' do
      get :overview
      response.body.should have_selector 'a', :text => I18n.t(:candidate_sign_up)
    end
    
    it 'should have a recruiter sign up button' do
      get :overview
      response.body.should have_selector 'a', :text => I18n.t(:recruiter_sign_up)
    end
    
    it 'should have a sign in link' do
      get :about
      response.body.should have_selector 'a', :text => I18n.t(:sign_in)
    end
    
    it 'should have a search bar' do
      get :about
      response.body.should have_selector 'form', :id => 'search_bar_form'
    end
  end

  describe "GET 'contact'" do
    
    it 'should return http success' do
      get :contact
      response.should be_success
    end
    
    it 'should have the right title' do
      get :contact
      response.body.should have_selector 'title', :text => "#{@base_title} | #{I18n.t(:menu_contact)}"
    end
    
    it 'should have the right selected navigation tab' do
      get :contact
      response.body.should have_selector 'li', :class => 'round selected', :text => I18n.t(:menu_contact)
    end
    
    it 'should have a candidate sign up button' do
      get :overview
      response.body.should have_selector 'a', :text => I18n.t(:candidate_sign_up)
    end
    
    it 'should have a recruiter sign up button' do
      get :overview
      response.body.should have_selector 'a', :text => I18n.t(:recruiter_sign_up)
    end
    
    it 'should have a sign in link' do
      get :contact
      response.body.should have_selector 'a', :text => I18n.t(:sign_in)
    end
    
    it 'should have a search bar' do
      get :contact
      response.body.should have_selector 'form', :id => 'search_bar_form'
    end
  end
end
