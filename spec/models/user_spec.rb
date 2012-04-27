require 'spec_helper'

describe User do
      
  before :each do
    @attr = { :first_name     => 'Juan',           :last_name     => 'Pablo',          :city           => 'Madrid',         
              :country        => 'Spain',          :nationality   => 'Spain',          :year_of_birth  => 1984,
              :phone          => '+34 6 88888888', :email         => 'jp@example.net', :facebook_login => 'jp@example.net',
              :linkedin_login => 'jp@example.net', :twitter_login => '@j_pablo',       :password       => 'pouetpouet38', :password_confirmation => 'pouetpouet38' }
    @user              = Factory :user
    @candidate         = Factory :candidate
    @recruiter         = Factory :recruiter
    @candidate_message = Factory :message, :author => @candidate, :recipient => @recruiter
    @recruiter_message = Factory :message, :author => @recruiter, :recipient => @candidate
  end
  
  it 'should create a new instance given valid attributes' do
    user = User.create! @attr
    user.should be_valid
  end
  
  describe 'messages associations' do
    
    it 'should have a messages attribute' do
      @user.should respond_to :authored_messages
    end
    
    it 'should have a messages attribute' do
      @user.should respond_to :received_messages
    end
    
    it 'should have a message_authors attribute' do
      @user.should respond_to :message_authors
    end
    
    it 'should have a message_recipients attribute' do
      @user.should respond_to :message_recipients
    end
    
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
  
  describe 'validation of' do
  
    describe 'first name and last name' do
    
      it 'should reject empty values' do
        empty_first_name_user = User.new @attr.merge :first_name => ''
        empty_last_name_user  = User.new @attr.merge :last_name  => ''
        empty_name_user       = User.new @attr.merge :first_name => '', :last_name => ''
        empty_first_name_user.should_not be_valid
        empty_last_name_user.should_not be_valid
        empty_name_user.should_not be_valid
      end
      
      it 'should reject too long first names' do
        long_first_name = 'f' * 81
        long_first_name_user = User.new @attr.merge :first_name => long_first_name
        long_first_name_user.should_not be_valid
      end
      
      it 'should reject too long last names' do
        long_last_name = 'f' * 81
        long_last_name_user = User.new @attr.merge :last_name => long_last_name
        long_last_name_user.should_not be_valid
      end
    end
    
    describe 'email address' do
    
      it 'should reject empty values' do
        empty_email_user = User.new @attr.merge :email => ''
        empty_email_user.should_not be_valid
      end
      
      it 'should reject invalid values' do
        invalid_emails = ['invalid_email', 'invalid@example', 'invalid@user@example.com', 'inv,alide@']
        invalid_emails.each do |invalid_email|
          invalid_email_user = User.new @attr.merge :email => invalid_email
          invalid_email_user.should_not be_valid
        end
      end
       
      it 'should reject duplicate values' do
        duplicate_email_user = User.new @attr.merge :email => @user.email
        duplicate_email_user.should_not be_valid
      end
       
      it 'should reject identical values up to case' do
        upcased_email_user = User.new @attr.merge :email => @user.email.upcase
        upcased_email_user.should_not be_valid
      end
       
      it 'should accept valid values' do
        valid_emails = ['valid_email@example.com', 'valid@example.co.kr', 'vu@example.us']
        valid_emails.each do |valid_email|
          valid_email_user = User.new @attr.merge :email => valid_email
          valid_email_user.should be_valid
        end
      end      
    end
    
    describe 'country' do
    
      it 'should reject empty values' do
        empty_country_user = User.new @attr.merge :country => ''
        empty_country_user.should_not be_valid
      end
      
      it 'should reject invalid values' do
        invalid_countries = [ 'SAVOIE', 'Rotterdam', '6552$%##', '__pouet_' ]
        invalid_countries.each do |invalid_country|
          invalid_country_user = User.new @attr.merge :country => invalid_country
          invalid_country_user.should_not be_valid
        end
      end
      
      it 'should accept valid values' do
        valid_countries = Country.all.collect { |c| c[0] }
        valid_countries.each do |valid_country|
          valid_country_user = User.new @attr.merge :country => valid_country
          valid_country_user.should be_valid
        end
      end
    end
    
    describe 'city' do
    
      it 'should reject empty values' do
        empty_city_user = User.new @attr.merge :city => ''
        empty_city_user.should_not be_valid
      end
    end
    
    describe 'year of birth' do
    
      it 'should accept empty values' do
        empty_year_of_birth_user = User.new @attr.merge :year_of_birth => ''
        empty_year_of_birth_user.should be_valid
      end
    
      it 'should reject too young users' do
        too_recent_year_of_birth = 11.years.ago
        too_young_user = User.new @attr.merge :year_of_birth => too_recent_year_of_birth
        too_young_user.should_not be_valid
      end
    end
    
    describe 'nationality' do
    
      it 'should accept empty values' do
        empty_nationality_user = User.new @attr.merge :nationality => ''
        empty_nationality_user.should be_valid
      end
      
      it 'should reject invalid values' do
        invalid_nationality_user = User.new @attr.merge :nationality => 'SAVOIE'
        invalid_nationality_user.should_not be_valid
      end
    end
    
    describe 'phone' do
    
      it 'should accept empty values' do
        empty_phone_number_user = User.new @attr.merge :phone => ''
        empty_phone_number_user.should be_valid
      end
      
      it 'should accept valid values' do
        valid_numbers = ['+31 6 31912261', '+33 4 76 30 49 76', '+31 631278086']
        valid_numbers.each do |valid_number|
            valid_number_user = User.new @attr.merge :phone => valid_number
            valid_number_user.should be_valid
        end
      end
      
      it 'should reject invalid values' do
        invalid_numbers = ['06 78 45 91 22', '0033 5 84 92 01 11', '+44 57', '41 (0) 456546456', '+1 98765432187898798798765434423534']
        invalid_numbers.each do |invalid_number|
          invalid_number_user = User.new @attr.merge :phone => invalid_number
          invalid_number_user.should_not be_valid
        end
      end
    end
    
    describe 'facebook login' do
    
      it 'should accept empty values' do
        empty_facebook_login_user = User.new @attr.merge :facebook_login => ''
        empty_facebook_login_user.should be_valid
      end
      
      it 'should accept valid values' do
        valid_facebook_logins = ['valid_facebook_login@example.com', 'valid@example.co.kr', 'vu@example.us']
        valid_facebook_logins.each do |valid_facebook_login|
          valid_facebook_login_user = User.new @attr.merge :facebook_login => valid_facebook_login
          valid_facebook_login_user.should be_valid
        end
      end
      
      it 'should reject invalid values' do
        invalid_facebook_logins = ['invalid_facebook_login', 'invalid@example', 'invalid@user@example.com', 'inv,alide@']
        invalid_facebook_logins.each do |invalid_facebook_login|
          invalid_facebook_login_user = User.new @attr.merge :facebook_login => invalid_facebook_login
          invalid_facebook_login_user.should_not be_valid
        end
      end
      
      it 'should reject duplicate values' do
        duplicate_facebook_login_user = User.new @attr.merge :facebook_login => @user.facebook_login
        duplicate_facebook_login_user.should_not be_valid
      end
      
      it 'should reject identical values up to case' do
        upcased_facebook_login_user = User.new @attr.merge :facebook_login => @user.facebook_login.upcase
        upcased_facebook_login_user.should_not be_valid
      end
    end
    
    describe 'linkedin login' do
    
      it 'should accept empty values' do
        empty_linkedin_login_user = User.new @attr.merge :linkedin_login => ''
        empty_linkedin_login_user.should be_valid
      end
      
      it 'should accept valid values' do
        valid_linkedin_logins = ['valid_linkedin_login@example.com', 'valid@example.co.kr', 'vu@example.us']
        valid_linkedin_logins.each do |valid_linkedin_login|
          valid_linkedin_login_user = User.new @attr.merge :linkedin_login => valid_linkedin_login
          valid_linkedin_login_user.should be_valid
        end
      end
      
      it 'should reject invalid values' do
        invalid_linkedin_logins = ['invalid_linkedin_login', 'invalid@example', 'invalid@user@example.com', 'inv,alide@']
        invalid_linkedin_logins.each do |invalid_linkedin_login|
          invalid_linkedin_login_user = User.new @attr.merge :linkedin_login => invalid_linkedin_login
          invalid_linkedin_login_user.should_not be_valid
        end
      end
      
      it 'should reject duplicate values' do
        duplicate_linkedin_login_user = User.new @attr.merge :linkedin_login => @user.linkedin_login
        duplicate_linkedin_login_user.should_not be_valid
      end
      
      it 'should reject identical values up to case' do
        upcased_linkedin_login_user = User.new @attr.merge :linkedin_login => @user.linkedin_login.upcase
        upcased_linkedin_login_user.should_not be_valid
      end
    end
     
    describe 'twitter login' do
    
      it 'should accept empty values' do
        empty_twitter_login_user = User.new @attr.merge :twitter_login => ''
        empty_twitter_login_user.should be_valid
      end
      
      it 'should accept valid values' do
        valid_twitter_logins = ['@dominic_m', '@_pouet_38', '@_1984', '@plop_2011']
        valid_twitter_logins.each do |valid_twitter_login|
          valid_twitter_login_user = User.new @attr.merge :twitter_login => valid_twitter_login
          valid_twitter_login_user.should be_valid
        end
      end
      
      it 'should reject invalid values' do
        invalid_twitter_logins = ['dominic', 'bill@u', '@31john', '@engaccino__support']
        invalid_twitter_logins.each do |invalid_twitter_login|
          invalid_twitter_login_user = User.new @attr.merge :twitter_login => invalid_twitter_login
          invalid_twitter_login_user.should_not be_valid
        end
      end
      
      it 'should reject duplicate values' do
        duplicate_twitter_login_user = User.new @attr.merge :twitter_login => @user.twitter_login
        duplicate_twitter_login_user.should_not be_valid
      end
      
      it 'should reject identical values up to case' do
        upcased_twitter_login_user = User.new @attr.merge :twitter_login => @user.twitter_login.upcase
        upcased_twitter_login_user.should_not be_valid
      end
    end
    
  end
  
  describe 'passwords' do
  
    it 'should have a password attribute' do
      @user.should respond_to :password
    end
    
    it 'should have a password confirmation attribute' do
      @user.should respond_to :password_confirmation
    end
    
    describe 'validations' do

      it 'should require a value' do
        no_password_user = User.new @attr.merge :password => '', :password_confirmation => ''
        no_password_user.should_not be_valid
      end

      it 'should require a matching confirmation' do
        no_password_confirmation_user = User.new @attr.merge :password_confirmation => 'invalid'
        no_password_confirmation_user.should_not be_valid
      end

      it 'should reject too short values' do
        short_password = 'a'*5
        too_short_password_user = User.new @attr.merge :password => short_password, :password_confirmation => short_password
        too_short_password_user.should_not be_valid
      end

      it 'should reject too long values' do
        long_password = 'a'*41
        too_long_password_user = User.new @attr.merge :password => long_password, :password_confirmation => long_password
        too_long_password_user.should_not be_valid
      end
    end
  end
  
  describe 'admin attribute' do
        
    it 'should exist' do
      @user.should respond_to :admin
    end
    
    it 'should not be true by default' do
      @user.should_not be_admin
    end
    
    it 'should be convertible to true' do
      @user.toggle! :admin
      @user.should be_admin
    end
  end
  
  describe 'profile completion attribute' do
  
    it 'should exist' do
      @user.should respond_to :profile_completion
    end
    
    it 'should be 0 by default' do
      @user.profile_completion.should == 0
    end
    
    it 'should reject negative values' do
      negative_profile_completion_user = User.new @attr.merge :profile_completion => -1
      negative_profile_completion_user.should_not be_valid
    end
    
    it 'should reject values superior to 100' do
      huge_profile_completion_user = User.new @attr.merge :profile_completion => 101
      huge_profile_completion_user.should_not be_valid
    end
    
    it 'should accept valid values' do
      valid_profile_completions = [10, 23, 38, 45, 51, 69, 84, 92]
      valid_profile_completions.each do |valid_profile_completion|
        valid_profile_completion_user = User.new @attr.merge :profile_completion => valid_profile_completion
        valid_profile_completion_user.should be_valid
      end
    end
  end
  
  describe 'image attribute' do
  
    it 'should have an image attribute' do
      @user.should respond_to :image
    end
    
    it 'should be default user by default' # do
    
  end
  
  describe 'password encryption' do
  
    it 'should have an encrypted pasword attribute' do
      @user.should respond_to :encrypted_password
    end
    
    it 'should set the encrypted password attribute' do
      @user.encrypted_password.should_not be_blank
    end
    
    it 'should have a salt' do
      @user.should respond_to :salt
    end
    
    describe 'has_password? method' do
    
      it 'should exist' do
        @user.should respond_to :has_password?
      end
      
      it 'should return true if the passwords match' do
        @user.has_password?(@user.password).should be_true
      end
      
      it 'should return false if the passwords do not match' do
        @user.has_password?('invalid').should be_false
      end
    end
    
    describe 'authenticate method' do
      
      it 'should exist' do
        User.should respond_to :authenticate
      end
      
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
    
    it 'should be true for candidates' do
      @candidate.candidate?.should == true
    end
    
    it 'should be false for recruiters' do
      @recruiter.candidate?.should == false
    end
  end
  
  describe 'recruiter? method' do
    
    it 'should be true for recruiters' do
      @recruiter.recruiter?.should == true
    end
    
    it 'should be false for candidates' do
      @candidate.recruiter?.should == false
    end
  end
  
  describe 'authored?(message) method' do
    
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

