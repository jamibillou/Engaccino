require 'spec_helper'

describe User do
      
  before :each do
    @attr = { :first_name => 'Juan', :last_name => 'Pablo', :city => 'Madrid', :country => 'Spain', :nationality => 'Spain', :year_of_birth  => 1984, :phone => '+34 6 88888888', :email => 'jp@example.net',
              :facebook_login => 'jp@example.net', :linkedin_login => 'jp@example.net', :twitter_login => '@j_pablo', :password => 'pouetpouet38', :password_confirmation => 'pouetpouet38' }
    @user              = Factory :user
    @candidate         = Factory :candidate
    @recruiter         = Factory :recruiter
    @candidate_message = Factory :message, :author => @candidate, :recipient => @recruiter
    @recruiter_message = Factory :message, :author => @recruiter, :recipient => @candidate
  end
  
  it 'should create a new instance given valid attributes' do
    User.create!(@attr).should be_valid
  end
  
  describe 'relationships associations' do
    
    before :each do
      @relationship = @recruiter.relationships.create! :followed_id => @candidate.id
    end
    
    it { @user.should respond_to :relationships }
    it { @user.should respond_to :reverse_relationships }
    it { @user.should respond_to :followed_users }
    it { @user.should respond_to :followers }
    
    it 'should have the right associated relationship' do
      @recruiter.relationships.first.should == @relationship
    end
    
    it 'should have the right associated reverse_relationship' do
      @candidate.reverse_relationships.first.should == @relationship
    end
    
    it 'should have the right associated followed_users' do
      @recruiter.followed_users.first.should == @candidate
    end
    
    it 'should have the right associated followers' do
      @candidate.followers.first.should == @recruiter
    end
    
    it 'should destroy the associated relationship' do
      @candidate.destroy
      Relationship.find_by_id(@relationship.id).should be_nil
    end
  end
  
  describe 'messages associations' do
    
    it { @user.should respond_to :authored_messages }
    it { @user.should respond_to :received_messages }
    it { @user.should respond_to :message_authors }
    it { @user.should respond_to :message_recipients }
    
    it 'should have the right associated message' do
      @candidate.authored_messages.first.should == @candidate_message
      @recruiter.received_messages.first.should == @candidate_message
    end
    
    it 'should have the right associated message_authors' do
      @candidate.message_recipients.first.should == @recruiter
    end
    
    it 'should have the right associated message_recipients' do
      @recruiter.message_authors.first.should == @candidate
    end
  end
  
  describe 'validations' do
    
    before :all do
      @email   = { :invalid => ['invalid_email','invalid@example','invalid@user@example.com','inv,alide@'], :valid => ['valid_email@example.com', 'valid@example.co.kr', 'vu@example.us'] }
      @country = { :invalid => [ 'SAVOIE', 'Rotterdam', '6552$%##', '__pouet_' ], :valid => Country.all.collect { |c| c[0] } }
      @phone   = { :invalid => ['06 78 45 91 22', '0033 5 84 92 01 11', '+44 57', '41 (0) 456546456', '+1 98765432187898798798765434423534'], :valid => ['+31 6 31912261', '+33 4 76 30 49 76', '+31 631278086'] }
      @twitter = { :invalid => ['dominic', 'bill@u', '@31john', '@engaccino__support'], :valid => ['@dominic_m', '@_pouet_38', '@_1984', '@plop_2011'] }
    end
      
    it { should validate_presence_of :first_name }
    it { should ensure_length_of(:first_name).is_at_most 80 }
    
    it { should validate_presence_of :last_name }
    it { should ensure_length_of(:last_name).is_at_most 80 }
    
    it { should validate_presence_of :country }
    it { should validate_format_of(:country).not_with(@country[:invalid]).with_message(I18n.t('activerecord.errors.messages.inclusion')) }
    it { should validate_format_of(:country).with @country[:valid] }
    
    it { should validate_presence_of :city }
    
    it { should_not validate_presence_of :year_of_birth }
    it { should ensure_inclusion_of(:year_of_birth).in_range 100.years.ago.year..Time.now.year }
    
    it { should_not validate_presence_of :nationality }
    it { should validate_format_of(:nationality).not_with(@country[:invalid]).with_message(I18n.t('activerecord.errors.messages.inclusion')) }
    it { should validate_format_of(:nationality).with @country[:valid] }
    
    it { should_not validate_presence_of :phone }
    it { should validate_format_of(:phone).not_with(@phone[:invalid]).with_message(I18n.t('activerecord.errors.messages.phone_format')) }
    it { should validate_format_of(:phone).with @phone[:valid] }
    
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_format_of(:email).not_with(@email[:invalid]).with_message(I18n.t('activerecord.errors.messages.email_format')) }
    it { should validate_format_of(:email).with @email[:valid] }
    
    it { should_not validate_presence_of :facebook_login }
    it { should validate_uniqueness_of(:facebook_login).case_insensitive }
    it { should validate_format_of(:facebook_login).not_with(@email[:invalid]).with_message(I18n.t('activerecord.errors.messages.email_format')) }
    it { should validate_format_of(:facebook_login).with @email[:valid] }
    
    it { should_not validate_presence_of :linkedin_login }
    it { should validate_uniqueness_of(:linkedin_login).case_insensitive }
    it { should validate_format_of(:linkedin_login).not_with(@email[:invalid]).with_message(I18n.t('activerecord.errors.messages.email_format')) }
    it { should validate_format_of(:linkedin_login).with @email[:valid] }
    
    it { should_not validate_presence_of :twitter_login }
    it { should validate_uniqueness_of(:twitter_login).case_insensitive }
    it { should validate_format_of(:twitter_login).not_with(@twitter[:invalid]).with_message(I18n.t('activerecord.errors.messages.twitter_format')) }
    it { should validate_format_of(:twitter_login).with @twitter[:valid] }
  end
  
  describe 'passwords' do
    
    it { should validate_presence_of :password }
    it { should ensure_length_of(:password).is_at_least(6).is_at_most 40 }
  
    it { @user.should respond_to :password }
    it { @user.should respond_to :password_confirmation }

    it 'should require a matching confirmation' do
      User.new(@attr.merge(:password_confirmation => 'invalid')).should_not be_valid
    end
  end
  
  describe 'admin attribute' do
        
    it { @user.should respond_to :admin }
    
    it 'should not be true by default' do
      @user.should_not be_admin
    end
    
    it 'should be convertible to true' do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end
  
  describe 'profile completion attribute' do
  
    it { @user.should respond_to :profile_completion }
    
    it 'should be 0 by default' do
      @user.profile_completion.should == 0
    end
    
    it 'should reject negative values' do
      User.new(@attr.merge(:profile_completion => -1)).should_not be_valid
    end
    
    it 'should reject values superior to 100' do
      User.new(@attr.merge(:profile_completion => 101)).should_not be_valid
    end
    
    it 'should accept valid values' do
      [10, 23, 38, 45, 51, 69, 84, 92].each do |valid_profile_completion|
        User.new(@attr.merge(:profile_completion => valid_profile_completion)).should be_valid
      end
    end
  end
  
  describe 'image attribute' do
  
    it { @user.should respond_to :image }    
  end
  
  describe 'password encryption' do
  
    it { @user.should respond_to :encrypted_password }
    it { @user.should respond_to :salt }
    
    it 'should set the encrypted password attribute' do
      @user.encrypted_password.should_not be_blank
    end
    
    describe 'has_password? method' do
    
      it { @user.should respond_to :has_password? }
      
      it 'should return true if the passwords match' do
        @user.has_password?(@user.password).should be_true
      end
      
      it 'should return false if the passwords do not match' do
        @user.has_password?('invalid').should be_false
      end
    end
    
    describe 'authenticate method' do
      
      it { User.should respond_to :authenticate }
      
      it 'should return nil on email/password mismatch' do
        User.authenticate(@user.email, 'wrongpass').should be_nil
      end
      
      it 'should return nil for an email with no user' do
        User.authenticate('dm@me.com', @user.password).should be_nil
      end
      
      it 'should return the user on email/password match' do
        User.authenticate(@user.email, @user.password).should == @user
      end
    end
  end
  
  describe 'candidate? method' do
    
    it { @user.should respond_to :candidate? }
    
    it 'should be true for candidates' do
      @candidate.candidate?.should == true
    end
    
    it 'should be false for recruiters' do
      @recruiter.candidate?.should == false
    end
  end
  
  describe 'recruiter? method' do
    
    it { @user.should respond_to :recruiter? }
    
    it 'should be true for recruiters' do
      @recruiter.recruiter?.should == true
    end
    
    it 'should be false for candidates' do
      @candidate.recruiter?.should == false
    end
  end
  
  describe 'relationships' do
    
    it { should respond_to :following? }
    it { should respond_to :follow! }
    it { should respond_to :unfollow! }
    
    before :each do
      @candidate.follow! @recruiter
    end
    
    it 'should be albe to follow another user' do
      @candidate.should be_following(@recruiter)
    end
    
    it 'should include the followed user in the followed users' do
      @candidate.followed_users.should include(@recruiter)
    end
      
    it 'should be albe to unfollow another user' do
      @candidate.unfollow! @recruiter
      @candidate.should_not be_following(@recruiter)
    end
    
    it 'should include the follower in the followers' do
      @recruiter.followers.should include(@candidate)
    end
  end
  
  describe 'authored? method' do
    
    it { @user.should respond_to :authored? }
    
    it 'should be true for authored messages' do
      @recruiter.authored?(@recruiter_message).should be_true
      @candidate.authored?(@candidate_message).should be_true
    end
    
    it 'should be false for received messages' do
      @recruiter.authored?(@candidate_message).should be_false
      @candidate.authored?(@recruiter_message).should be_false
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                 :integer(4)      not null, primary key
#  first_name         :string(255)
#  last_name          :string(255)
#  city               :string(255)
#  country            :string(255)
#  nationality        :string(255)
#  year_of_birth      :integer(4)
#  phone              :string(255)
#  email              :string(255)
#  facebook_login     :string(255)
#  linkedin_login     :string(255)
#  twitter_login      :string(255)
#  status             :string(255)
#  type               :string(255)
#  facebook_connect   :boolean(1)      default(FALSE)
#  linkedin_connect   :boolean(1)      default(FALSE)
#  twitter_connect    :boolean(1)      default(FALSE)
#  profile_completion :integer(4)      default(0)
#  admin              :boolean(1)      default(FALSE)
#  salt               :string(255)
#  encrypted_password :string(255)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  image              :string(255)
#  main_education     :integer(4)
#  main_experience    :integer(4)
#  quote              :string(255)
#  company_id         :integer(4)
#

