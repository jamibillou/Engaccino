require 'spec_helper'

describe "Messages" do

  before :each do
    @candidate = Factory :candidate
    @candidate.update_attributes :profile_completion => 5
    visit signin_path
    fill_in 'email',    :with => @candidate.email
    fill_in 'password', :with => @candidate.password
    click_button "#{I18n.t('sessions.new.signin')}"
    visit messages_path    
  end

  describe 'standard blocks' do
  
    it 'should have a left menu' do
      page.should have_selector 'div#menu_left'
    end
    
    it 'should have a conversation block' do
      page.should have_selector 'div#conversation'
    end
    
    it "should have a 'Messages' title" do
      find('div#container').find('h1').should have_content I18n.t('messages.title') 
    end
    
    it "should have a 'New conversation' link" do
      find('div#menu_left').should have_content I18n.t('messages.new_conversation')
    end 
  end  

  describe 'when empty' do
    
    it "should have an 'empty' message" do
      find('div#conversation').should have_content I18n.t('messages.no_conversation')
    end  
  end
end
