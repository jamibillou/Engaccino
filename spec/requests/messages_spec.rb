require 'spec_helper'

describe "Messages" do

  describe 'standard blocks' do
  
    before :each do
      @candidate  = Factory :candidate, :profile_completion => 5
      visit signin_path
      fill_in 'email',    :with => @candidate.email
      fill_in 'password', :with => @candidate.password
      click_button "#{I18n.t('sessions.new.signin')}"
      visit messages_path    
    end
  
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
    
    describe 'when empty' do
    
      it "should have an 'empty' message" do
        find('div#conversation').should have_content I18n.t('messages.no_conversation')
      end  
    end 
  end 
  
  describe 'when containing a conversation' do
    before :each do
      @recruiter  = Factory :recruiter, :profile_completion => 5
      @candidate  = Factory :candidate, :profile_completion => 5
      @messages   = [ (Factory :message, :author => @candidate,  :recipient => @recruiter),
                      (Factory :message, :author => @recruiter,  :recipient => @candidate) ]
      visit signin_path
      fill_in 'email',    :with => @candidate.email
      fill_in 'password', :with => @candidate.password
      click_button "#{I18n.t('sessions.new.signin')}"
      visit messages_path    
    end
    
    it "should have a block with the recipient description" do
      page.should have_selector "div#contact_#{@recruiter.id}"
    end
    
    it "should have a new message block" do
      page.should have_selector "div#new_message"
    end
    
    it "should have a block containing every messages" do
      @messages.each do |message|
        find("div#message_#{message.id}").should have_content message.content
      end
    end    
  end
  
 
end
