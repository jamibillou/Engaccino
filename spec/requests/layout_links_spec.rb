require 'spec_helper'

describe 'LayoutLinks' do

  it 'should have the right pages at public URLs' do
    get '/'
    response.should have_selector 'title', :content => I18n.t(:menu_overview)
    get '/tour'
    response.should have_selector 'title', :content => I18n.t(:menu_tour)
    get '/pricing'
    response.should have_selector 'title', :content => I18n.t(:menu_pricing)
    get '/about'
    response.should have_selector 'title', :content => I18n.t(:menu_about)
    get '/contact'
    response.should have_selector 'title', :content => I18n.t(:menu_contact)
    get '/signup'
    response.should have_selector 'title', :content => I18n.t('users.new.title')
    get '/signin'
    response.should have_selector 'title', :content => I18n.t('sessions.new.title')
  end
  
  describe 'for non-signed-in users' do
    
    it 'should have the right links on the layout' do 
      visit root_path
      response.should have_selector 'title', :content => I18n.t(:menu_overview)
      click_link I18n.t(:menu_overview)
      response.should have_selector 'title', :content => I18n.t(:menu_overview)
      click_link I18n.t(:menu_tour)
      response.should have_selector 'title', :content => I18n.t(:menu_tour)
      click_link I18n.t(:menu_pricing)
      response.should have_selector 'title', :content => I18n.t(:menu_pricing)
      click_link I18n.t(:menu_about)
      response.should have_selector 'title', :content => I18n.t(:menu_about)
      click_link I18n.t(:menu_contact)
      response.should have_selector 'title', :content => I18n.t(:menu_contact)
      click_link I18n.t(:sign_up)
      response.should have_selector 'title', :content => I18n.t('users.new.title')
      click_link I18n.t(:sign_in)
      response.should have_selector 'title', :content => I18n.t('sessions.new.title')
      click_link I18n.t(:sign_up)
      response.should have_selector 'title', :content => I18n.t('users.new.title')
    end          											 
  end
  
  describe 'for signed-in users' do
    
    before :each do
      @candidate = Factory :candidate
      visit signin_path
      fill_in :email,    :with => @candidate.email
      fill_in :password, :with => @candidate.password
      click_button
    end
    
    describe "who haven't completed signup" do
      
      it 'should have the right links on the layout' do 
        visit root_path
        response.should have_selector 'a', :content => I18n.t(:menu_overview)
        response.should have_selector 'a', :content => I18n.t(:menu_tour)
        response.should have_selector 'a', :content => I18n.t(:menu_pricing)
        response.should have_selector 'a', :content => I18n.t(:menu_about)
        response.should have_selector 'a', :content => I18n.t(:menu_contact)
        response.should have_selector 'a', :content => I18n.t(:sign_in)
        response.should have_selector 'a', :content => I18n.t(:sign_up)
      end 
    end
    
    describe 'who have completed signup' do
      
      it 'should have the right links on the layout' do 
        @candidate.update_attributes :profile_completion => 5
        visit root_path
        response.should have_selector 'a', :href => '#',                        :content => I18n.t(:menu_dashboard)
        response.should have_selector 'a', :href => candidate_path(@candidate), :content => I18n.t(:menu_profile)
        response.should have_selector 'a', :href => signout_path,               :content => I18n.t(:sign_out)
        response.should have_selector 'a>img', :class => 'settings'
      end
    end
  end
end