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
    
    it 'should have a block with the recipient description' do
      page.should have_selector "div#contact_#{@recruiter.id}"
    end
    
    it 'should have a new message block' do
      page.should have_selector "div#new_message"
    end
    
    it 'should have a block containing every messages' do
      @messages.each do |message|
        find("div#message_#{message.id}").should have_content message.content
      end
    end
    
    it 'should contain messages content on the recruiter profile page' do
      visit recruiter_path @recruiter
      page.should have_selector "div#card_messages"
      @messages.each do |message|
        find('div#card_messages').should have_content message.content
      end
    end    
  end
  
  describe 'Message block on profile' do
    before :each do
      require 'coffee_script'
      @recruiter  = Factory :recruiter, :profile_completion => 5
      @candidate  = Factory :candidate, :profile_completion => 5
      visit signin_path
      fill_in 'email',    :with => @candidate.email
      fill_in 'password', :with => @candidate.password
      click_button "#{I18n.t('sessions.new.signin')}"
      visit recruiter_path @recruiter
    end
    
    it "should have a 'no message' title" do    
      find('div#card_messages').should have_content "#{I18n.t('contact')} #{@recruiter.first_name}"
    end
    
    describe 'if messages have been written' do      
      before :each do
        @messages   = [ (Factory :message, :author => @candidate,  :recipient => @recruiter),
                        (Factory :message, :author => @recruiter,  :recipient => @candidate) ]
        visit recruiter_path @recruiter
      end
      
      it 'should have a block containing all messages' do
        @messages.each do |message|
          find('div#card_messages').should have_content message.content
        end 
      end
    end
    
    describe "'new message' form", :js => true do
      describe 'failure' do
        it "should display an error message when we try to send an empty message" do
          click_button "#{I18n.t('send')}"
          find('div#message_status').should have_content I18n.t('activerecord.errors.messages.empty')
        end
      end 
      
      describe 'success' do
        before :each do
          fill_in 'message_content',      :with => 'Pouet pouet'
          click_button "#{I18n.t('send')}"
        end
        
        it 'should create a message' do
          lambda do
            sleep(3)
          end.should change(Message, :count).by(1)
        end
        
        it 'should display the created message' do
          sleep(2)
          find('div#card_messages').should have_content 'Pouet pouet'
        end
      end
    end
  end
  
  describe 'ajax', :js => true do
    before :each do
      require 'coffee_script'
      require 'less'
      @recruiter1 = Factory :recruiter, :profile_completion => 5
      @recruiter2 = Factory :recruiter, :email => Factory.next(:email), :facebook_login => Factory.next(:facebook_login),
                                        :linkedin_login => Factory.next(:linkedin_login), :twitter_login => Factory.next(:twitter_login), :profile_completion => 5
      @candidate  = Factory :candidate, :profile_completion => 5
      @messages   = [ (Factory :message, :author => @candidate,  :recipient => @recruiter1),
                      (Factory :message, :author => @recruiter1,  :recipient => @candidate) ]
      visit signin_path
      fill_in 'email',    :with => @candidate.email
      fill_in 'password', :with => @candidate.password
      click_button "#{I18n.t('sessions.new.signin')}"
      visit messages_path
    end
    
    describe 'new conversation' do
      before :each do
        click_link "#{I18n.t('messages.new_conversation')}"
      end
      
      it 'should display a new conversation form' do
        page.should have_selector "div#new_conversation"
      end
      
      it 'should hide the form by clicking to the cross icon' do
        click_link 'close_conversation'
        find('div#new_conversation').visible?.should be_false
      end
      
      it 'should have an error message when an empty form is submitted' do
        click_button "#{I18n.t('send')}"
        sleep(3)
        find('div#new_conversation').visible?.should be_true
        find('div#message_errors').should have_content I18n.t('message.validations.different_classes_of_user')
      end
      
      describe 'success' do
        before :each do
          fill_in 'message_content',      :with => "Lorem ipsum dolor sit amet, consectetur adipisicing elit"
          fill_in 'recipient',            :with => "#{@recruiter2.first_name}"
          sleep(3)
          page.execute_script "$('.ui-menu-item a:contains(#{@recruiter2.first_name})').first().trigger('mouseenter').click();"
          page.execute_script "$('#message_recipient_id').val(#{@recruiter2.id});"
          click_button "#{I18n.t('send')}"
        end
        
        it 'should hide the form and contain a new message form' do
          sleep(3)
          page.should_not have_selector 'div#new_conversation'
          page.should have_selector 'div#new_message'
        end
        
        it 'should create a message' do
          lambda do
            sleep(4)
          end.should change(Message, :count).by(1)
        end
        
        it 'should have a block with the new recipient on the left menu' do
          sleep(3)
          page.should have_selector "div#contact_#{@recruiter2.id}"
        end
      end
    end
    
    describe 'new message' do
      before :each do
        find("div#contact_#{@recruiter1.id}").click
      end
      
      it 'should have a new message form' do
        find('form#new_message').visible?.should be_true
      end
      
      it 'should display an error message when an empty form is submitted' do
        click_button "#{I18n.t('send')}"
        sleep(2)
        find('form#new_message').visible?.should be_true
        find('div#message_errors').should have_content I18n.t('activerecord.errors.messages.empty')
      end
      
      describe 'success' do
        before :each do
          fill_in 'message_content', :with => "Bla bla bla"
          click_button "#{I18n.t('send')}"
        end
        
        it 'should create a message' do
          lambda do
            sleep(2)        
          end.should change(Message, :count).by(1)
        end
        
        it 'should display the new message, with the submitted content' do
          sleep(3)
          find("div#message_#{Message.last.id}").should have_content "Bla bla bla"
        end
      end
    end
    
    describe 'archiving conversation' do
      before :each do
        click_link "archive_#{@recruiter1.id}"
      end
      
      it 'should not have a block with the recipient description anymore' do
        sleep(3)
        page.should_not have_selector "div#contact_#{@recruiter1.id}"
      end
      
      it 'should not destroy the related messages in the db' do
        lambda do
          sleep(2)
        end.should_not change(Message, :count).by(1)
      end    
    end
  end  
end
