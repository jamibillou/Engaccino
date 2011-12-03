require 'spec_helper'

describe User do
      
  before(:each) do
    @attr = {
      :first_name => "Juan",
      :last_name => "Pablo",
      :city => "Madrid",         
      :country => "ES",
      :nationality => "ES",
      :year_of_birth => 1984,
      :phone => "+34 6 88888888",
      :email => "jp@example.net",
      :facebook_login => "jp@example.net",
      :linkedin_login => "jp@example.net",
      :twitter_login => "@j_pablo",
      :password => "pouetpouet38",
      :password_confirmation => "pouetpouet38"
    }
    @user = Factory(:user)
  end
  
  it "should create a new instance given valid attributes" do
    user = User.create!(@attr)
    user.should be_valid
  end
  
  describe "mandatory attributes" do
  
    describe ":first_name, :last_name" do
    
      it "should not accept empty first names or last names" do
        empty_first_name_user = User.new(@attr.merge(:first_name => ""))
        empty_last_name_user = User.new(@attr.merge(:last_name => ""))
        empty_name_user = User.new(@attr.merge(:first_name => "", :last_name => ""))
        empty_first_name_user.should_not be_valid
        empty_last_name_user.should_not be_valid
        empty_name_user.should_not be_valid
      end
      
      it "should reject too long first names" do
        long_first_name = "f" * 81
        long_first_name_user = User.new(@attr.merge(:first_name => long_first_name))
        long_first_name_user.should_not be_valid
      end
      
      it "should reject too long last names" do
        long_last_name = "f" * 81
        long_last_name_user = User.new(@attr.merge(:last_name => long_last_name))
        long_last_name_user.should_not be_valid
      end
    end
    
    describe ":email" do
    
      it "should reject empty emails addresses" do
        empty_email_user = User.new(@attr.merge(:email => ""))
        empty_email_user.should_not be_valid
      end
      
      it "should reject invalid email addresses" do
        invalid_emails = ['invalid_email', 'invalid@example', 'invalid@user@example.com', 'inv,alide@']
        invalid_emails.each do |invalid_email|
          invalid_email_user = User.new(@attr.merge(:email => invalid_email))
          invalid_email_user.should_not be_valid
        end
      end
       
      it "should reject duplicate email addresses" do
        duplicate_email_user = User.new(@attr.merge(:email => @user.email))
        duplicate_email_user.should_not be_valid
      end
       
      it "should reject identical email addresses up to case" do
        upcased_email_user = User.new(@attr.merge(:email => @user.email.upcase))
        upcased_email_user.should_not be_valid
      end
       
      it "should accept valid email addresses" do
        valid_emails = ['valid_email@example.com', 'valid@example.co.kr', 'vu@example.us']
        valid_emails.each do |valid_email|
          valid_email_user = User.new(@attr.merge(:email => valid_email))
          valid_email_user.should be_valid
        end
      end
    end
  end
  
  describe "optional attributes" do
    
    describe ":country" do
    
      it "should accept empty countries" do
        empty_country_user = User.new(@attr.merge(:country => ""))
        empty_country_user.should be_valid
      end
      
      it "should reject invalid countries" do
        invalid_country_user = User.new(@attr.merge(:country => "SAVOIE"))
        invalid_country_user.should_not be_valid
      end
    end
    
    describe ":year_of_birth" do
    
      it "should accept empty year of birth" do
        empty_year_of_birth_user = User.new(@attr.merge(:year_of_birth => ""))
        empty_year_of_birth_user.should be_valid
      end
    
      it "should reject birthdays of users born less than 12 years ago" do
        too_recent_year_of_birth = 11.years.ago
        too_recent_year_of_birth_user = User.new(@attr.merge(:year_of_birth => too_recent_year_of_birth))
        too_recent_year_of_birth_user.should_not be_valid
      end
    end
    
    describe ":nationality" do
    
      it "should accept empty nationalities" do
        empty_nationality_user = User.new(@attr.merge(:nationality => ""))
        empty_nationality_user.should be_valid
      end
      
      it "should reject invalid nationalities" do
        invalid_nationality_user = User.new(@attr.merge(:nationality => "SAVOIE"))
        invalid_nationality_user.should_not be_valid
      end
    end
    
    describe ":phone" do
    
      it "should accept empty phone numbers" do
        empty_phone_number_user = User.new(@attr.merge(:phone => ""))
        empty_phone_number_user.should be_valid
      end
      
      it "should accept valid phone numbers" do
        valid_numbers = ['+31 6 31912261', '+33 4 76 30 49 76', '+31 631278086']
        valid_numbers.each do |valid_number|
            valid_number_user = User.new(@attr.merge(:phone => valid_number))
            valid_number_user.should be_valid
        end
      end
      
      it "should reject invalid phone numbers" do
        invalid_numbers = ['06 78 45 91 22', '0033 5 84 92 01 11', '+44 567', '41 (0) 456546456', '+1 98765432187898798798765434423534']
        invalid_numbers.each do |invalid_number|
          invalid_number_user = User.new(@attr.merge(:phone => invalid_number))
          invalid_number_user.should_not be_valid
        end
      end
    end
    
    describe ":facebook_login" do
    
      it "should accept empty facebook logins" do
        empty_facebook_login_user = User.new(@attr.merge(:facebook_login => ""))
        empty_facebook_login_user.should be_valid
      end
      
      it "should accept valid facebook logins" do
        valid_facebook_logins = ['valid_facebook_login@example.com', 'valid@example.co.kr', 'vu@example.us']
        valid_facebook_logins.each do |valid_facebook_login|
          valid_facebook_login_user = User.new(@attr.merge(:facebook_login => valid_facebook_login))
          valid_facebook_login_user.should be_valid
        end
      end
      
      it "should reject invalid facebook logins" do
        invalid_facebook_logins = ['invalid_facebook_login', 'invalid@example', 'invalid@user@example.com', 'inv,alide@']
        invalid_facebook_logins.each do |invalid_facebook_login|
          invalid_facebook_login_user = User.new(@attr.merge(:facebook_login => invalid_facebook_login))
          invalid_facebook_login_user.should_not be_valid
        end
      end
      
      it "should reject duplicate facebook logins" do
        duplicate_facebook_login_user = User.new(@attr.merge(:facebook_login => @user.facebook_login))
        duplicate_facebook_login_user.should_not be_valid
      end
      
      it "should reject identical facebook logins up to case" do
        upcased_facebook_login_user = User.new(@attr.merge(:facebook_login => @user.facebook_login.upcase))
        upcased_facebook_login_user.should_not be_valid
      end
    end
    
    describe ":linkedin_login" do
    
      it "should accept empty linkedin logins" do
        empty_linkedin_login_user = User.new(@attr.merge(:linkedin_login => ""))
        empty_linkedin_login_user.should be_valid
      end
      
      it "should accept valid linkedin logins" do
        valid_linkedin_logins = ['valid_linkedin_login@example.com', 'valid@example.co.kr', 'vu@example.us']
        valid_linkedin_logins.each do |valid_linkedin_login|
          valid_linkedin_login_user = User.new(@attr.merge(:linkedin_login => valid_linkedin_login))
          valid_linkedin_login_user.should be_valid
        end
      end
      
      it "should reject invalid linkedin logins" do
        invalid_linkedin_logins = ['invalid_linkedin_login', 'invalid@example', 'invalid@user@example.com', 'inv,alide@']
        invalid_linkedin_logins.each do |invalid_linkedin_login|
          invalid_linkedin_login_user = User.new(@attr.merge(:linkedin_login => invalid_linkedin_login))
          invalid_linkedin_login_user.should_not be_valid
        end
      end
      
      it "should reject duplicate linkedin logins" do
        duplicate_linkedin_login_user = User.new(@attr.merge(:linkedin_login => @user.linkedin_login))
        duplicate_linkedin_login_user.should_not be_valid
      end
      
      it "should reject identical linkedin logins up to case" do
        upcased_linkedin_login_user = User.new(@attr.merge(:linkedin_login => @user.linkedin_login.upcase))
        upcased_linkedin_login_user.should_not be_valid
      end
    end
     
    describe ":twitter_login" do
    
      it "should accept empty twitter logins" do
        empty_twitter_login_user = User.new(@attr.merge(:twitter_login => ""))
        empty_twitter_login_user.should be_valid
      end
      
      it "should accept valid twitter logins" do
        valid_twitter_logins = ['@dominic_m', '@_pouet_38', '@_1984', '@plop_2011']
        valid_twitter_logins.each do |valid_twitter_login|
          valid_twitter_login_user = User.new(@attr.merge(:twitter_login => valid_twitter_login))
          valid_twitter_login_user.should be_valid
        end
      end
      
      it "should reject invalid twitter logins" do
        invalid_twitter_logins = ['dominic', 'bill@u', '@31john', '@engaccino__support']
        invalid_twitter_logins.each do |invalid_twitter_login|
          invalid_twitter_login_user = User.new(@attr.merge(:twitter_login => invalid_twitter_login))
          invalid_twitter_login_user.should_not be_valid
        end
      end
      
      it "should reject duplicate twitter logins" do
        duplicate_twitter_login_user = User.new(@attr.merge(:twitter_login => @user.twitter_login))
        duplicate_twitter_login_user.should_not be_valid
      end
      
      it "should reject identical twitter logins up to case" do
        upcased_twitter_login_user = User.new(@attr.merge(:twitter_login => @user.twitter_login.upcase))
        upcased_twitter_login_user.should_not be_valid
      end
    end
  end
  
  describe "passwords" do
  
    it "should have a :password attribute" do
      @user.should respond_to(:password)
    end
    
    it "should have a password confirmation attribute" do
      @user.should respond_to(:password_confirmation)
    end
  end
  
  describe "password validations" do
    
    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
    end
    
    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
    end
    
    it "should reject too short passwords" do
      short = "a" * 5
      attr = @attr.merge(:password => short, :password_confirmation => short)
      User.new(attr).should_not be_valid
    end
    
    it "should reject too long passwords" do
      long = "a" * 41
      attr = @attr.merge(:password => long, :password_confirmation => long)
      User.new(attr).should_not be_valid
    end
  end
  
  describe "password encryption" do
  
    it "should have an encrypted pasword attribute" do
      @user.should respond_to(:encrypted_password)
    end
    
    it "should set the encrypted_password attribute" do
      @user.encrypted_password.should_not be_blank
    end
    
    it "should have a salt" do
      @user.should respond_to(:salt)
    end
    
    describe "has_password? method" do
    
      it "should exist" do
        @user.should respond_to(:has_password?)
      end
      
      it "should return true if the passwords match" do
        @user.has_password?(@user.password).should be_true
      end
      
      it "should return false if the passwords do not match" do
        @user.has_password?("invalid").should be_false
      end
    end
    
    describe "authenticate method" do
      
      it "should exist" do
        User.should respond_to(:authenticate)
      end
      
      it "should return nil on email/password mismatch" do
        User.authenticate(@user.email, "wrongpass").should be_nil
      end
      
      it "should return nil for an email with no user" do
        User.authenticate("dm@me.com", @user.password).should be_nil
      end
      
      it "should return the user on email/password match" do
        User.authenticate(@user.email, @user.password).should == @user
      end
    end
  end
  
  describe "attribute :admin" do
        
    it "should respond to admin" do
      @user.should respond_to(:admin)
    end
    
    it "should not be an admin by default" do
      @user.should_not be_admin
    end
    
    it "should be convertible to admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end 
end

# == Schema Information
#
# Table name: users
#
#  id                 :integer(4)      not null, primary key
#  first_name         :string(255)
#  middle_name        :string(255)
#  last_name          :string(255)
#  city               :string(255)
#  country            :string(255)
#  nationality        :string(255)
#  birthdate          :date
#  phone              :string(255)
#  email              :string(255)
#  facebook_login     :string(255)
#  linkedin_login     :string(255)
#  twitter_login      :string(255)
#  facebook_connect   :boolean(1)      default(FALSE)
#  linkedin_connect   :boolean(1)      default(FALSE)
#  twitter_connect    :boolean(1)      default(FALSE)
#  admin              :boolean(1)      default(FALSE)
#  encrypted_password :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  salt               :string(255)
#  year_of_birth      :integer(4)
#

