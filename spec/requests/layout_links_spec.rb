require 'spec_helper'

describe 'LayoutLinks' do

  it 'should have the right pages at public URLs' do
      visit '/'
      find('title').should have_content I18n.t(:menu_overview)
      visit '/tour'
      find('title').should have_content I18n.t(:menu_tour)
      visit '/pricing'
      find('title').should have_content I18n.t(:menu_pricing)
      visit '/about'
      find('title').should have_content I18n.t(:menu_about)
      visit '/contact'
      find('title').should have_content I18n.t(:menu_contact)
      visit '/candidate_signup'
      find('title').should have_content I18n.t('candidates.new.title')
      visit '/recruiter_signup'
      find('title').should have_content I18n.t('recruiters.new.title')
      visit '/signin'
      find('title').should have_content I18n.t('sessions.new.title')
    end
    
    describe 'for non-signed-in users' do
      
      it 'should have the right links on the layout' do 
        visit root_path
        find('title').should have_content I18n.t(:menu_overview)
        click_link I18n.t(:menu_overview)
        find('title').should have_content I18n.t(:menu_overview)
        click_link I18n.t(:menu_tour)
        find('title').should have_content I18n.t(:menu_tour)
        click_link I18n.t(:menu_pricing)
        find('title').should have_content I18n.t(:menu_pricing)
        click_link I18n.t(:menu_about)
        find('title').should have_content I18n.t(:menu_about)
        click_link I18n.t(:menu_contact)
        find('title').should have_content I18n.t(:menu_contact)
        click_link I18n.t(:sign_in)
        find('title').should have_content I18n.t('sessions.new.title')
        click_link I18n.t(:sign_up)
        find('title').should have_content I18n.t('candidates.new.title')
      end                                
    end
    
    # describe 'for signed-in candidates' do
    #   
    #   before :each do
    #     @candidate = Factory :candidate
    #     visit signin_path
    #     fill_in :email,    :with => @candidate.email
    #     fill_in :password, :with => @candidate.password
    #     click_button
    #   end
    #   
    #   describe "who haven't completed signup" do
    #     
    #     it 'should have the right links on the layout' do 
    #       visit root_path
    #       response.should have_selector 'a', :content => I18n.t(:menu_overview)
    #       response.should have_selector 'a', :content => I18n.t(:menu_tour)
    #       response.should have_selector 'a', :content => I18n.t(:menu_pricing)
    #       response.should have_selector 'a', :content => I18n.t(:menu_about)
    #       response.should have_selector 'a', :content => I18n.t(:menu_contact)
    #       response.should have_selector 'a', :content => I18n.t(:sign_in)
    #       response.should have_selector 'a', :content => I18n.t(:sign_up)
    #     end 
    #   end
    #   
    #   describe 'who have completed signup' do
    #     
    #     it 'should have the right links on the layout' do 
    #       @candidate.update_attributes :profile_completion => 5
    #       visit root_path
    #       response.should have_selector 'a', :href => '#',                        :content => I18n.t(:menu_dashboard)
    #       response.should have_selector 'a', :href => candidate_path(@candidate), :content => I18n.t(:menu_profile)
    #       response.should have_selector 'a', :href => recruiters_path,            :content => I18n.t(:menu_recruiters)
    #       response.should have_selector 'a', :href => signout_path,               :content => I18n.t(:sign_out)
    #       response.should have_selector 'a>img', :class => 'settings'
    #     end
    #   end
    # end
    # 
    # describe 'for signed-in recruiters' do
    #   
    #   before :each do
    #     @recruiter = Factory :recruiter
    #     visit signin_path
    #     fill_in :email,    :with => @recruiter.email
    #     fill_in :password, :with => @recruiter.password
    #     click_button
    #   end
    #   
    #   describe "who haven't completed signup" do
    #     
    #     it 'should have the right links on the layout' do 
    #       visit root_path
    #       response.should have_selector 'a', :content => I18n.t(:menu_overview)
    #       response.should have_selector 'a', :content => I18n.t(:menu_tour)
    #       response.should have_selector 'a', :content => I18n.t(:menu_pricing)
    #       response.should have_selector 'a', :content => I18n.t(:menu_about)
    #       response.should have_selector 'a', :content => I18n.t(:menu_contact)
    #       response.should have_selector 'a', :content => I18n.t(:sign_in)
    #       response.should have_selector 'a', :content => I18n.t(:sign_up)
    #     end 
    #   end
    #   
    #   describe 'who have completed signup' do
    #     
    #     it 'should have the right links on the layout' do 
    #       @recruiter.update_attributes :profile_completion => 5
    #       visit root_path
    #       response.should have_selector 'a', :href => '#',                        :content => I18n.t(:menu_dashboard)
    #       response.should have_selector 'a', :href => recruiter_path(@recruiter), :content => I18n.t(:menu_profile)
    #       response.should have_selector 'a', :href => candidates_path,            :content => I18n.t(:menu_candidates)
    #       response.should have_selector 'a', :href => signout_path,               :content => I18n.t(:sign_out)
    #       response.should have_selector 'a>img', :class => 'settings'
    #     end
    #   end
    # end
end