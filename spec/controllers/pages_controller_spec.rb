require 'spec_helper'

describe PagesController do

  render_views
  
  before :each do
    @base_title = 'Engaccino'
  end
  
  describe "GET 'overview'" do
    
    before :each do
      get :overview
    end
        
    it 'should return http success' do
      response.should be_success
    end
    
    it 'should have the right title' do
      response.body.should have_selector 'title', :text => "#{@base_title} | #{I18n.t(:menu_overview)}"
    end
    
    it 'should have the right selected navigation tab' do
      response.body.should have_selector 'li', :class => 'round selected', :text => I18n.t(:menu_overview)
    end
  end

  describe "GET 'tour'" do
    
    before :each do
      get :tour
    end
          
    it 'should return http success' do
      response.should be_success
    end
    
    it 'should have the right title' do
      response.body.should have_selector 'title', :text => "#{@base_title} | #{I18n.t(:menu_tour)}"
    end
    
    it 'should have the right selected navigation tab' do
      response.body.should have_selector 'li', :class => 'round selected', :text => I18n.t(:menu_tour)
    end
  end

  describe "GET 'pricing'" do
    
    before :each do
      get :pricing
    end
    
    it 'should return http success' do
      response.should be_success
    end
    
    it 'should have the right title' do
      response.body.should have_selector 'title', :text => "#{@base_title} | #{I18n.t(:menu_pricing)}"
    end
    
    it 'should have the right selected navigation tab' do
      response.body.should have_selector 'li', :class => 'round selected', :text => I18n.t(:menu_pricing)
    end
  end

  describe "GET 'about'" do
    
    before :each do
      get :about
    end
    
    it 'should return http success' do
      response.should be_success
    end
    
    it 'should have the right title' do
      response.body.should have_selector 'title', :text => "#{@base_title} | #{I18n.t(:menu_about)}"
    end
    
    it 'should have the right selected navigation tab' do
      response.body.should have_selector 'li', :class => 'round selected', :text => I18n.t(:menu_about)
    end
  end

  describe "GET 'contact'" do
    
    before :each do
      get :contact
    end
    
    it 'should return http success' do
      response.should be_success
    end
    
    it 'should have the right title' do
      response.body.should have_selector 'title', :text => "#{@base_title} | #{I18n.t(:menu_contact)}"
    end
    
    it 'should have the right selected navigation tab' do
      response.body.should have_selector 'li', :class => 'round selected', :text => I18n.t(:menu_contact)
    end
  end
end