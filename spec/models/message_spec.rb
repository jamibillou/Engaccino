require 'spec_helper'

describe Message do
  
  before :each do
    @attr         = { :content => 'Sample content' }
    @candidate1   = Factory :candidate
    @candidate2   = Factory :candidate, :email => Factory.next(:email), :facebook_login => Factory.next(:facebook_login),
                                        :linkedin_login => Factory.next(:linkedin_login), :twitter_login => Factory.next(:twitter_login)
    @recruiter1   = Factory :recruiter
    @recruiter2   = Factory :recruiter, :email => Factory.next(:email), :facebook_login => Factory.next(:facebook_login),
                                        :linkedin_login => Factory.next(:linkedin_login), :twitter_login => Factory.next(:twitter_login)
    @message      = Factory :message,   :author => @candidate1, :recipient => @recruiter1
  end
  
  it 'should create a new instance given valid attributes' do
    message = Message.new @attr ; message.author = @candidate1 ; message.recipient = @recruiter1 ; 
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
      @message.author.should    == @candidate1
      @message.author.id.should == @candidate1.id
    end
    
    it 'should have the right associated recipient' do
      @message.recipient.should    == @recruiter1
      @message.recipient.id.should == @recruiter1.id
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
      no_author_message = Message.new @attr ; no_author_message.recipient = @recruiter1
      no_author_message.should_not be_valid
    end
    
    it 'should require a recipient' do
      no_recipient_message = Message.new @attr ; no_recipient_message.author = @candidate1
      no_recipient_message.should_not be_valid
    end
    
    it 'should reject identical authors and recipients' do
      same_user_message = Message.new @attr ; same_user_message.author = @candidate1 ; same_user_message.recipient = @candidate1 ; 
      same_user_message.should_not be_valid
    end
    
    it 'should reject authors and recipients with them same class' do
      same_class_message = Message.new @attr ; same_class_message.author = @candidate1 ; same_class_message.recipient = @candidate2 ; 
      same_class_message.should_not be_valid
      same_class_message = Message.new @attr ; same_class_message.author = @recruiter1 ; same_class_message.recipient = @recruiter2 ; 
      same_class_message.should_not be_valid
    end
    
    it 'should reject invalid/empty read attributes' do
      invalid_reads = ['aaa',12,'']
      invalid_reads.each do |invalid_read|
        Message.new(:content => 'Bla bla', :read => invalid_read).should_not be_valid
      end      
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
#  read         :boolean(1)      default(FALSE)
#

