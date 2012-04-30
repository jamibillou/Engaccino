require 'spec_helper'

describe MessagesController do

  render_views

  before :each do
    @candidate  = Factory :candidate, :profile_completion => 5
    @recruiter1 = Factory :recruiter, :profile_completion => 5
    @recruiter2 = Factory :recruiter, :email => Factory.next(:email), :facebook_login => Factory.next(:facebook_login), :linkedin_login => Factory.next(:linkedin_login), :twitter_login => Factory.next(:twitter_login), :profile_completion => 5
    @attr       = { :content => 'Sample content', :author_id => @candidate, :recipient_id => @recruiter1 }
    @messages   = [ (Factory :message, :author => @candidate,  :recipient => @recruiter1), (Factory :message, :author => @recruiter1, :recipient => @candidate), (Factory :message, :author => @candidate, :recipient => @recruiter2), (Factory :message, :author => @recruiter2, :recipient => @candidate) ]
    test_sign_in @candidate
  end
  
  describe "GET 'index'" do
    
    before :each do
      get :index
    end
    
    it 'should return http success' do
      response.should be_success
    end
    
    it 'should have the right title' do
      response.body.should have_selector 'title', :text => I18n.t('messages.title')
    end
    
    it 'should have the right selected navigation tab' do
      response.body.should have_selector 'li', :class => 'round selected', :text => I18n.t(:menu_messages)
    end
    
    it 'should have a conversation for each messaged contact' do 
      @candidate.messaged_contacts do |contact|
        response.body.should have_selector :id => "contact_#{contact.id}"
      end  
    end
    
    it 'should have all the messages of the last conversation' do 
      response.body.should include "message_#{@messages[2].id}", "message_#{@messages[3].id}"
    end
    
    it 'should not have messages from other conversations' do
      response.body.should_not include "message_#{@messages[0].id}", "message_#{@messages[1].id}"
    end
  end
  
  describe "GET 'show'" do
          
    before :each do
      xhr :get, :show, :current_contact => @recruiter2.id
    end
    
    it 'should respond http success' do
      response.should be_success
    end
    
    it 'should display a conversation' do
      response.should render_template :partial => '_conversation'
    end
      
    it 'should have all the messages of the corresponding conversation' do
      response.body.should include "message_#{@messages[2].id}", "message_#{@messages[3].id}"
    end
      
    it 'should not have messages from other conversations' do
      response.body.should_not include "message_#{@messages[0].id}", "message_#{@messages[1].id}"
    end
      
    it 'should not have a new conversation form' do
      response.body.should_not have_selector '#new_conversation'
    end
  end
  
  describe "GET 'new'" do
    
    before :each  do
      xhr :get, :new
    end
          
    it 'should respond http success' do
      response.should be_success
    end
    
    it 'should have a new conversation form' do
      response.body.should have_selector '#new_conversation'
    end
      
    it 'should not have messages' do
      response.body.should_not include "message_#{@messages[0].id}", "message_#{@messages[1].id}", "message_#{@messages[2].id}", "message_#{@messages[3].id}"
    end
  end
  
  describe "POST 'create'" do
    
    before :each do
      lambda do
        xhr :post, :create, :message => @attr
      end.should change(Message, :count).by 1
    end
    
    it 'should respond http success' do
      response.should be_success
    end
  end
  
  describe "GET 'menu_top'" do
    
    before :each do
      @candidate.messages.each { |message| message.destroy }
      xhr :get, :menu_top
    end
    
    it 'should respond http success' do
      response.should be_success
    end
    
    it 'should not have an unread mark' do
      response.body.should_not have_selector 'span'
    end
    
    it 'should have an unread mark' do
      Factory :message, :author => @recruiter1, :recipient => @candidate
      xhr :get, :menu_top
      response.body.should have_selector 'span'
    end
  end
  
  describe "GET 'menu_left'" do
    
    before :each do
      @candidate.messages.each { |message| message.update_attributes :read => true }
      xhr :get, :menu_left
    end
    
    it 'should respond http success' do
      response.should be_success
    end
    
    it 'should have a conversation per messaged contact' do
      @candidate.messaged_contacts.each do |contact|
        response.body.should include "contact_#{contact.id}"
      end
    end
    
    it 'should have a selected conversation' do
      response.body.should include 'selected'
    end
    
    it 'should not have unread marks for conversations without unread message' do
      @candidate.messaged_contacts.each do |contact|
        response.body.should_not include "unread_#{contact.id}"
      end
    end
    
    it 'should have unread marks for conversations with unread messages' do
      Factory :message, :author => @recruiter1, :recipient => @candidate
      xhr :get, :menu_left
      response.body.should include "unread_#{@recruiter1.id}"
    end
  end
  
  describe "GET 'archive'" do
    
    before :each do
      xhr :get, :archive, :current_contact => @recruiter1.id
    end
    
    it 'should respond http success' do
      response.should be_success
    end
    
    it "should archive the conversation on the current user's side" do
      Message.where(:author_id => @recruiter1, :recipient_id => @candidate).each do |message|
        message.archived_recipient.should == true
      end
      Message.where(:author_id => @candidate, :recipient_id => @recruiter1).each do |message|
        message.archived_author.should == true
      end
    end
    
    it "shouldn't archive the conversation on the current contact's side" do
      Message.where(:author_id => @recruiter1, :recipient_id => @candidate).each do |message|
        message.archived_author.should == false
      end
      Message.where(:author_id => @candidate, :recipient_id => @recruiter1).each do |message|
        message.archived_recipient.should == false
      end
    end
  end
end