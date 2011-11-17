require 'spec_helper'

describe User do
      
  before(:each) do
    @attributes = {
      :first_name => "Juan",
      :middle_name => "",
      :last_name => "Pablo",
      :city => "Madrid",         
      :country => "SP",
      :nationality => "Spanish",
      :birthdate => 25.years.ago,
      :phone => "+34 6 88888888",
      :email => "jp@example.net",
      :facebook_login => "jp@example.net",
      :linkedin_login => "jp@example.net",
      :twitter_login => "@j_pablo"
    }
    @user = Factory(:user)
  end
   
  it "should create a new instance given valid attributes" do
    user = User.create!(@attributes)
    user.should be_valid
  end
  
  it "should reject empty first names or last names" do
    no_first_name_user = User.new(@attributes.merge(:first_name => ""))
    no_last_name_user = User.new(@attributes.merge(:last_name => ""))
    no_name_user = User.new(@attributes.merge(:first_name => "", :last_name => ""))
    no_first_name_user.should_not be_valid
    no_last_name_user.should_not be_valid
    no_name_user.should_not be_valid
  end

  it "should accept valid phone numbers" do
    valid_numbers = ['+31 6 31912261', '+33 4 76 30 49 76', '+31 631278086']
    valid_numbers.each do |valid_number|
        valid_number_user = User.new(@attributes.merge(:phone => valid_number))
        valid_number_user.should be_valid
    end
  end
  
  it "should reject invalid phone numbers" do
    invalid_numbers = ['06 78 45 91 22', '0033 5 84 92 01 11', '+44 567', '41 (0) 456546456', '+1 98765432187898798798765434423534']
    invalid_numbers.each do |invalid_number|
      invalid_number_user = User.new(@attributes.merge(:phone => invalid_number))
      invalid_number_user.should_not be_valid
    end
  end
  
  it "should reject too long first names" do
    long_first_name = "f" * 81
    long_first_name_user = User.new(@attributes.merge(:first_name => long_first_name))
    long_first_name_user.should_not be_valid
  end
  
  it "should reject too long middle names" do
    long_middle_name = "f" * 81
    long_middle_name_user = User.new(@attributes.merge(:middle_name => long_middle_name))
    long_middle_name_user.should_not be_valid
  end
  
  it "should reject too long last names" do
    long_last_name = "f" * 81
    long_last_name_user = User.new(@attributes.merge(:last_name => long_last_name))
    long_last_name_user.should_not be_valid
  end
  
  it "should reject empty emails addresses" do
    no_email_user = User.new(@attributes.merge(:email => ""))
    no_email_user.should_not be_valid
  end
  
  it "should accept valid email addresses" do
    valid_emails = ['valid_email@example.com', 'valid@example.co.kr', 'vu@example.us']
    valid_emails.each do |valid_email|
      valid_email_user = User.new(@attributes.merge(:email => valid_email))
      valid_email_user.should be_valid
    end
  end
 
  it "should reject invalid email addresses" do
    invalid_emails = ['invalid_email', 'invalid@example', 'invalid@user@example.com', 'inv,alide@']
    invalid_emails.each do |invalid_email|
      invalid_email_user = User.new(@attributes.merge(:email => invalid_email))
      invalid_email_user.should_not be_valid
    end
  end
  
  it "should reject countries that are not contained in the list" do
    invalid_country_user = User.new(@attributes.merge(:country => "SAVOIE"))
    invalid_country_user.should_not be_valid
  end
  
  it "should reject duplicate email addresses" do
    duplicate_email_user = User.new(@attributes.merge(:email => @user.email))
    duplicate_email_user.should_not be_valid
  end
  
  it "should reject identical email addresses up to case" do
    upcased_email_user = User.new(@attributes.merge(:email => @user.email.upcase))
    upcased_email_user.should_not be_valid
  end
  
  it "should accept valid facebook logins" do
    valid_facebook_logins = ['valid_facebook_login@example.com', 'valid@example.co.kr', 'vu@example.us']
    valid_facebook_logins.each do |valid_facebook_login|
      valid_facebook_login_user = User.new(@attributes.merge(:facebook_login => valid_facebook_login))
      valid_facebook_login_user.should be_valid
    end
  end
  
  it "should reject invalid facebook logins" do
    invalid_facebook_logins = ['invalid_facebook_login', 'invalid@example', 'invalid@user@example.com', 'inv,alide@']
    invalid_facebook_logins.each do |invalid_facebook_login|
      invalid_facebook_login_user = User.new(@attributes.merge(:facebook_login => invalid_facebook_login))
      invalid_facebook_login_user.should_not be_valid
    end
  end
  
  it "should reject duplicate facebook logins" do
    duplicate_facebook_login_user = User.new(@attributes.merge(:facebook_login => @user.facebook_login))
    duplicate_facebook_login_user.should_not be_valid
  end
  
  it "should reject identical facebook logins up to case" do
    upcased_facebook_login_user = User.new(@attributes.merge(:facebook_login => @user.facebook_login.upcase))
    upcased_facebook_login_user.should_not be_valid
  end
  
  it "should accept valid linkedin logins" do
    valid_linkedin_logins = ['valid_linkedin_login@example.com', 'valid@example.co.kr', 'vu@example.us']
    valid_linkedin_logins.each do |valid_linkedin_login|
      valid_linkedin_login_user = User.new(@attributes.merge(:linkedin_login => valid_linkedin_login))
      valid_linkedin_login_user.should be_valid
    end
  end
  
  it "should reject invalid linkedin logins" do
    invalid_linkedin_logins = ['invalid_linkedin_login', 'invalid@example', 'invalid@user@example.com', 'inv,alide@']
    invalid_linkedin_logins.each do |invalid_linkedin_login|
      invalid_linkedin_login_user = User.new(@attributes.merge(:linkedin_login => invalid_linkedin_login))
      invalid_linkedin_login_user.should_not be_valid
    end
  end
  
  it "should reject duplicate linkedin logins" do
    duplicate_linkedin_login_user = User.new(@attributes.merge(:linkedin_login => @user.linkedin_login))
    duplicate_linkedin_login_user.should_not be_valid
  end
  
  it "should reject identical linkedin logins up to case" do
    upcased_linkedin_login_user = User.new(@attributes.merge(:linkedin_login => @user.linkedin_login.upcase))
    upcased_linkedin_login_user.should_not be_valid
  end
  
  describe "admin attribute" do
        
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
#  facebook_connect   :boolean(1)
#  linkedin_connect   :boolean(1)
#  twitter_connect    :boolean(1)
#  admin              :boolean(1)      default(FALSE)
#  encrypted_password :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

