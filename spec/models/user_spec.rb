require 'spec_helper'

describe User do
      
  before(:each) do
    @attributes = {
      :first_name => "John",
      :middle_name => "",
      :last_name => "Doe",
      :city => "Rotterdam",         
      :country => "Netherlands (The)",
      :nationality => "A-marrocan",
      :birthdate => 40.years.ago,
      :phone => "+31 6 00000000",
      :email => "j.doe@example.com",
      :facebook_login => "j.doe@example.com",
      :linkedin_login => "j.doe@example.com",
      :twitter_login => "@john_d"
    }
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
  
  it "should reject duplicate email addresses" do
    user = Factory(:user, :email => Factory.next(:email))
    duplicate_email_user = User.new(@attributes.merge(:email => user.email))
    duplicate_email_user.should_not be_valid
  end
  
  it "should reject identical email address up to case" do
    user = Factory(:user, :email => Factory.next(:email))
    upcased_email_user = User.new(@attributes.merge(:email => user.email.upcase))
    upcased_email_user.should_not be_valid
  end
  
  describe "admin attribute" do
    
    before(:each) do
      @user = Factory(:user, :email => Factory.next(:email))      
    end
    
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

