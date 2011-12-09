require 'spec_helper'

describe "LayoutLinks" do

  it "should have a logo with a link" do
    get '/'
    response.should have_selector('a>img', :id => 'logo')
  end
  
  it "should have an Overview page at '/'"  do 
    get '/'
    response.should be_success
    response.should have_selector('title', :content => I18n.t(:menu_overview))
  end
  
  it "should have a Tour page at '/tour'" do 
    get '/tour'
    response.should be_success
    response.should have_selector('title', :content => I18n.t(:menu_tour))
  end
  
  it "should have an Pricing page at '/pricing'" do 
    get '/pricing'
    response.should be_success
    response.should have_selector('title', :content => I18n.t(:menu_pricing))
  end
  
  it "should have an About page at '/about'" do 
    get '/about'
    response.should be_success
    response.should have_selector('title', :content => I18n.t(:menu_about))
  end
  
  it "should have a Contact page at '/contact'" do 
    get '/contact'
    response.should be_success
    response.should have_selector('title', :content => I18n.t(:menu_contact))
  end
  
  it "should have a Sign up page at '/signup'" do 
    get '/signup'
    response.should be_success
    response.should have_selector('title', :content => I18n.t('users.new.title'))
  end
  
  it "should have a Sign in page at '/signin'" do 
    get '/signin'
    response.should be_success
    response.should have_selector('title', :content => I18n.t('sessions.new.title'))
  end
  
  describe "when not signed in" do
    
    it "should have the right links on the layout" do 
      visit root_path
      response.should have_selector('title', :content => I18n.t(:menu_overview))
      click_link I18n.t(:menu_overview)
      response.should have_selector('title', :content => I18n.t(:menu_overview))
      click_link I18n.t(:menu_tour)
      response.should have_selector('title', :content => I18n.t(:menu_tour))
      click_link I18n.t(:menu_pricing)
      response.should have_selector('title', :content => I18n.t(:menu_pricing))
      click_link I18n.t(:menu_about)
      response.should have_selector('title', :content => I18n.t(:menu_about))
      click_link I18n.t(:menu_contact)
      response.should have_selector('title', :content => I18n.t(:menu_contact))
      click_link I18n.t(:sign_up)
      response.should have_selector('title', :content => I18n.t('users.new.title'))
      click_link I18n.t(:sign_in)
      response.should have_selector('title', :content => I18n.t('sessions.new.title'))
    end
    
    it "should have a signin link" do
      visit root_path
      response.should have_selector("a", :href => signin_path, :content => I18n.t(:sign_in))
    end  
    
    it "should have a signup link" do
      visit root_path
      response.should have_selector("a", :href => signup_path, :content => I18n.t(:sign_up))
    end           											 
  end
  
  describe "when signed in" do
    
    before(:each) {
      @user = Factory(:user)
      visit signin_path
      fill_in :email,    :with => @user.email
      fill_in :password, :with => @user.password
      click_button
    }
    
    it "should have a dashboard link" do
      response.should have_selector("a", :href => '#', :content => I18n.t(:menu_dashboard))
    end
    
    it "should have a profile link" do
      response.should have_selector("a", :href => user_path(@user), :content => I18n.t(:menu_profile))
    end
    
    it "should have an edit link" do
      response.should have_selector("a", :href => edit_user_path(@user), :content => I18n.t(:menu_edit))
    end
    
    it "should have a signout link" do
      response.should have_selector("a", :href => signout_path, :content => I18n.t(:sign_out))
    end
    
    it "should have a settings link" do
      response.should have_selector("a>img", :class => 'settings')
    end
  end
end