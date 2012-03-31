require 'spec_helper'

describe Message do
  
  before :each do
    @attr    = { :content => 'Sample content' }
    @user1   = Factory :user
    @user2   = Factory :user, :email => Factory.next(:email), :facebook_login => Factory.next(:facebook_login),
                              :linkedin_login => Factory.next(:linkedin_login), :twitter_login => Factory.next(:twitter_login)
    @message = Factory :message, :author => @user1, :recipient => @user2
  end
  
  it 'should create a new instance given valid attributes' do
    message = Message.new @attr ; message.author = @user1 ; message.recipient = @user2 ; 
    message.should be_valid
  end
  
  describe 'users aossciations' do
    
    it 'should have an author attribute' do
      @message.should respond_to :author
    end
    
    it 'should have a recipient attribute' do
      @message.should respond_to :recipient
    end
    
    it 'should have the right associated author' do
      @message.author.should       == @user1
      @message.author.id.should    == @user1.id
    end
    
    it 'should have the right associated recipient' do
      @message.recipient.should    == @user2
      @message.recipient.id.should == @user2.id
    end
  end
  
  describe 'validations' do
    
    it 'should require a content' do
      Message.new(:content => '').should_not be_valid
    end
    
    it 'should reject to long contents' do
      too_long_content = 'a' * 141
      Message.new(:content => too_long_content).should_not be_valid
    end
    
    it 'should require an author' do
      no_author_message = Message.new @attr ; no_author_message.recipient = @user2
      no_author_message.should_not be_valid
    end
    
    it 'should require a recipient' do
      no_recipient_message = Message.new @attr ; no_recipient_message.author = @user1
      no_recipient_message.should_not be_valid
    end
  end
end

# == Schema Information
#
# Table name: messages
#
#  id           :integer(4)      not null, primary key
#  content      :string(255)
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  author_id    :integer(4)
#  recipient_id :integer(4)
#

