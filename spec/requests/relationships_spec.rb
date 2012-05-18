require 'spec_helper'

describe "Relationships" do

  before :each do
    require 'coffee_script'
    @candidate = Factory :candidate, :profile_completion => 5
    @recruiter = Factory :recruiter, :profile_completion => 5
    @recruiter2 = Factory :recruiter, :email => Factory.next(:email), :facebook_login => Factory.next(:facebook_login), :linkedin_login => Factory.next(:linkedin_login), :twitter_login => Factory.next(:twitter_login), :profile_completion => 5
    visit signin_path
    fill_in 'email',    :with => @candidate.email
    fill_in 'password', :with => @candidate.password
    click_button "#{I18n.t('sessions.new.signin')}"
    visit recruiter_path @recruiter
  end

  describe 'Follow/Unfollow link on profile page' do
      
    it 'should have a follow button' do
      find('div#follow_share').should have_content I18n.t('follow')
    end
    
    describe "when we click on the 'follow' link", :js => true do
      
      before :each do
        click_link I18n.t('follow')
        sleep(1)
      end
      
      it 'should change the text of the link' do
        find('div#follow_share').should have_content I18n.t('unfollow')
      end
      
      it 'should have done the relationship between the two users' do
        @candidate.followed_users.should include @recruiter
        @recruiter.followers.should      include @candidate
      end
      
      describe "when we click on the 'unfollow' link" do
        before :each do
          click_link I18n.t('unfollow')
          sleep(1)
        end
        
        it 'should change the text of the link again' do
          find('div#follow_share').should have_content I18n.t('follow')
        end
        
        it 'should have removed the relationship betweend the two users' do
          @candidate.followed_users.should_not include @recruiter
          @recruiter.followers.should_not      include @candidate            
        end
      end
    end 
  end
    
  describe 'Following/followers menus on index page', :js => true do
    before :each do
      sleep(1)
      visit recruiters_path
    end
    
    it 'should have the 3 menus on the left' do
      find('#following').should have_content I18n.t('users.following')
      find('#followers').should have_content I18n.t('users.followers')
      find('#all').should have_content I18n.t('all')
    end
    
    it 'should display recruiters cards' do
      find("div#recruiter_#{@recruiter.id}").should have_content  "#{@recruiter.first_name} #{@recruiter.last_name}"
      find("div#recruiter_#{@recruiter2.id}").should have_content "#{@recruiter2.first_name} #{@recruiter2.last_name}"
    end
    
    it "should not display anything when we click on the 'following' link" do
      click_link I18n.t('users.following')
      sleep(1)
      page.should_not have_selector "div#recruiter_#{@recruiter.id}"
      page.should_not have_selector "div#recruiter_#{@recruiter2.id}"
    end
    
    it "should not display anything when we click on the 'followers' link" do
      click_link I18n.t('users.followers')
      sleep(1)
      page.should_not have_selector "div#recruiter_#{@recruiter.id}"
      page.should_not have_selector "div#recruiter_#{@recruiter2.id}"
    end
    
    describe "after a 'follow' action" do
      before :each do
        visit recruiter_path @recruiter
        click_link I18n.t('follow')
        sleep(1)
        visit recruiters_path
      end
      
      it "should display the recruiter 1's card but not the recruiter 2's one when we click on the 'following' link" do
        click_link I18n.t('users.following')
        sleep(1)
        find("div#recruiter_#{@recruiter.id}").should have_content  "#{@recruiter.first_name} #{@recruiter.last_name}"
        page.should_not have_selector "div#recruiter_#{@recruiter2.id}"
      end
      
      it "should not display anything when we click on the 'followers' link" do
        click_link I18n.t('users.followers')
        sleep(1)
        page.should_not have_selector "div#recruiter_#{@recruiter.id}"
        page.should_not have_selector "div#recruiter_#{@recruiter2.id}"
      end
      
      describe 'from the recruiter point of view' do
        before :each do
          click_link I18n.t('sign_out')
          visit signin_path
          fill_in 'email',    :with => @recruiter.email
          fill_in 'password', :with => @recruiter.password
          click_button "#{I18n.t('sessions.new.signin')}"
          visit candidates_path
        end
        
        it "should not display anything when we click on the 'following' link" do
          click_link I18n.t('users.following')
          sleep(1)
          page.should_not have_selector "div#candidate_#{@candidate.id}"
        end
        
        it "should display the candidate's card when we click on the 'followers' link" do
          click_link I18n.t('users.followers')
          sleep(1)
          find("div#candidate_#{@candidate.id}").should have_content  "#{@candidate.first_name} #{@candidate.last_name}"
        end          
      end
    end
  end    
end
