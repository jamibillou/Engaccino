require 'spec_helper'

describe MessagesController do

  render_views

  before :each do
    @attr       = { :content => 'Sample content' }
    @candidate  = Factory :candidate, :profile_completion => 5
    @recruiter1 = Factory :recruiter, :profile_completion => 5
    @recruiter2 = Factory :recruiter, :email => Factory.next(:email), :facebook_login => Factory.next(:facebook_login),
                                      :linkedin_login => Factory.next(:linkedin_login), :twitter_login => Factory.next(:twitter_login), :profile_completion => 5
    @messages   = [ (Factory :message, :author => @candidate,  :recipient => @recruiter1),
                    (Factory :message, :author => @recruiter1, :recipient => @candidate),
                    (Factory :message, :author => @candidate,  :recipient => @recruiter2),
                    (Factory :message, :author => @recruiter2, :recipient => @candidate) ]
    test_sign_in @candidate
  end
  
  describe "GET 'index'" do
    
    it 'should return http success' do
      get :index
      response.should be_success
    end
    
    it 'should have the right title' do
      get :index
      response.body.should have_selector 'title', :text => I18n.t('messages.title')
    end
    
    it 'should have the right selected navigation tab' do
      get :index
      response.body.should have_selector 'li', :class => 'round selected', :text => I18n.t(:menu_messages)
    end
    
    it 'should have a conversation for each messaged contact' do 
      get :index
      @candidate.messaged_contacts do |contact|
        response.body.should have_selector :id => "contact_#{contact.id}"
      end  
    end
    
    it 'have all the messages of the last conversation' do 
      get :index
      response.body.should include "message_#{@messages[2].id}"
      response.body.should include "message_#{@messages[3].id}"
    end
    
    it 'not have messages from other conversations' do
      get :index
      response.body.should_not include "message_#{@messages[0].id}"
      response.body.should_not include "message_#{@messages[1].id}"
    end
  end
  
  describe "GET 'show'" do
    
    describe 'failure' do
      
      it 'should fail using the html format' do
        get :show, :current_contact => @recruiter1.id
        response.should redirect_to @candidate
        flash[:notice].should == I18n.t('flash.notice.restricted_page')
      end
    end
    
    describe 'success' do
      
      it 'should respond http success' do
        xhr :get, :show, :current_contact => @recruiter1.id
        response.should be_success
      end
    
      it 'should display a conversation' do
        xhr :get, :show, :current_contact => @recruiter1.id
        response.should render_template(:partial => '_conversation')
      end
      
      it 'have all the messages of the corresponding conversation' do
        xhr :get, :show, :current_contact => @recruiter2.id
        response.body.should include "message_#{@messages[2].id}"
        response.body.should include "message_#{@messages[3].id}"
      end
      
      it 'not have messages from other conversations' do
        xhr :get, :show, :current_contact => @recruiter2.id
        response.body.should_not include "message_#{@messages[0].id}"
        response.body.should_not include "message_#{@messages[1].id}"
      end
      
      it 'should not have a new conversation form' do
        xhr :get, :show, :current_contact => @recruiter1.id
        response.body.should_not have_selector '#new_conversation'
      end
    end
  end
  
  describe "GET 'new'" do
    
    describe 'failure' do
      
      it 'should fail using the html format' do
        get :new
        response.should redirect_to @candidate
        flash[:notice].should == I18n.t('flash.notice.restricted_page')
      end
    end
    
    describe 'success' do
      
      it 'should respond http success' do
        xhr :get, :new
        response.should be_success
      end
    
      it 'should have a new conversation form' do
        xhr :get, :new
        response.body.should have_selector '#new_conversation'
      end
      
      it 'not have messages' do
        xhr :get, :new
        response.body.should_not include "message_#{@messages[0].id}"
        response.body.should_not include "message_#{@messages[1].id}"
        response.body.should_not include "message_#{@messages[2].id}"
        response.body.should_not include "message_#{@messages[3].id}"
      end
    end
  end
  
  describe "PUT 'create'" do
    
    describe 'failure' do
      
      it 'should fail using the html format' do
        put :create @attr
        response.should redirect_to @candidate
        flash[:notice].should == I18n.t('flash.notice.restricted_page')
      end
    end
    
    describe 'success' do
      
      it 'should respond http success' do
        xhr :put, :create @attr
        response.should be_success
      end
    end
  end
end
