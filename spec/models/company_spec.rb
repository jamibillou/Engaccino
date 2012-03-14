require 'spec_helper'

describe Company do

  before :each do
    @attr = { :name => 'Engaccino',
              :address => 'Currently unkown',
              :city => 'Rotterdam',
              :country => 'Netherlands',
              :phone => '+31 6 00000000',
              :email => 'info@engaccino.com',
              :url => 'http://www.engaccino.com' }  
    @candidate  = Factory :candidate
    @company    = Factory :company
    @recruiter  = Factory :recruiter,  :company => @company
    @experience = Factory :experience, :candidate => @candidate, :company => @company
  end
  
  it 'should create a new instance given valid attributes' do
    company = Company.create! @attr
    company.should be_valid
  end
  
  describe 'experiences associations' do
    
    it 'should have an experiences attribute' do
      @company.should respond_to :experiences
    end
    
    it 'should destroy associated experiences' do
      @company.destroy
      Experience.find_by_id(@experience.id).should be_nil
    end    
  end
  
  describe 'candidates associations' do
    
    it 'should have a candidates attribute' do
      @company.should respond_to :candidates
    end
    
    it 'should not destroy associated candidates' do
      @company.destroy
      Candidate.find_by_id(@candidate.id).should_not be_nil
    end    
  end
  
  describe 'recruiters associations' do
    
    it 'should have a recruiters attribute' do
      @company.should respond_to :candidates
    end
    
    it 'should not destroy associated recruiters' do
      @company.destroy
      Recruiter.find_by_id(@recruiter.id).should_not be_nil
    end    
  end
  
  describe 'validations' do
    
    it 'should require a name' do
      empty_name_company = Company.new @attr.merge :name => ''
      empty_name_company.should_not be_valid
    end
    
    it 'should reject too long names' do
      too_long_name = 'a'*81
      too_long_name_company = Company.new @attr.merge:name => too_long_name
      too_long_name_company.should_not be_valid
    end
    
    it 'should accept empty addresses' do
      empty_address_company = Company.new @attr.merge :address => ''
      empty_address_company.should be_valid
    end
    
    it 'should reject too long addresses' do
      too_long_address = 'a'*161
      too_long_address_company = Company.new @attr.merge :address => too_long_address
      too_long_address_company.should_not be_valid
    end
    
    it 'should accept require a city' do
      empty_city_company = Company.new @attr.merge :city => ''
      empty_city_company.should_not be_valid
    end
    
    it 'should reject too long cities' do
      too_long_city = 'a'*81
      too_long_city_company = Company.new @attr.merge :city => too_long_city
      too_long_city_company.should_not be_valid
    end
    
    it 'should require a country' do
      empty_country_company = Company.new @attr.merge :country => ''
      empty_country_company.should_not be_valid
    end
    
    it 'should reject invalid countries' do
      invalid_countries = [ 'SAVOIE', 'Rotterdam', '6552$%##', '__pouet_' ]
      invalid_countries.each do |invalid_country|
        invalid_country_company = Company.new @attr.merge :country => invalid_country
        invalid_country_company.should_not be_valid
      end
    end
    
    it 'should accept valid countries' do
      valid_countries = Country.all.collect { |c| c[0] }
      valid_countries.each do |valid_country|
        valid_country_company = Company.new @attr.merge :country => valid_country
        valid_country_company.should be_valid
      end
    end
    
    it 'should accept empty phone numbers' do
      empty_phone_number_company = Company.new @attr.merge :phone => ''
      empty_phone_number_company.should be_valid
    end
    
    it 'should accept valid phone numbers' do
      valid_numbers = ['+31 6 31912261', '+33 4 76 30 49 76', '+31 631278086']
      valid_numbers.each do |valid_number|
          valid_number_company = Company.new @attr.merge :phone => valid_number
          valid_number_company.should be_valid
      end
    end
    
    it 'should reject invalid phone numbers' do
      invalid_numbers = ['06 78 45 91 22', '0033 5 84 92 01 11', '+44 57', '41 (0) 456546456', '+1 98765432187898798798765434423534']
      invalid_numbers.each do |invalid_number|
        invalid_number_company = Company.new @attr.merge :phone => invalid_number
        invalid_number_company.should_not be_valid
      end
    end
    
    it 'should accept empty emails addresses' do
      empty_email_company = Company.new @attr.merge :email => ''
      empty_email_company.should be_valid
    end
    
    it 'should reject invalid email addresses' do
      invalid_emails = ['invalid_email', 'invalid@example', 'invalid@user@example.com', 'inv,alide@']
      invalid_emails.each do |invalid_email|
        invalid_email_company = Company.new @attr.merge :email => invalid_email
        invalid_email_company.should_not be_valid
      end
    end
     
    it 'should reject duplicate email addresses' do
      duplicate_email_company = Company.new @attr.merge :email => @company.email
      duplicate_email_company.should_not be_valid
    end
     
    it 'should reject identical email addresses up to case' do
      upcased_email_company = Company.new @attr.merge :email => @company.email.upcase
      upcased_email_company.should_not be_valid
    end
     
    it 'should accept valid email addresses' do
      valid_emails = ['valid_email@example.com', 'valid@example.co.kr', 'vu@example.us']
      valid_emails.each do |valid_email|
        valid_email_company = Company.new @attr.merge :email => valid_email
        valid_email_company.should be_valid
      end
    end
    
    it 'shoud accept empty URLs' do
      empty_url_company = Company.new @attr.merge :url => ''
      empty_url_company.should be_valid
    end
    
    it 'shoud reject invalid URLs' do
      invalid_urls = ['invalid_url',
                      'engaccino.com',
                      'pouetpouetpouet',
                      'http:www.engaccino.com',
                      'http//engaccino.com',
                      'http/ccino.co',
                      'htp://ccino.me',
                      'http:/www.engaccino.com',
                      'http://j ai des espaces. fr' ]
      invalid_urls.each do |invalid_url|
        invalid_url_company = Company.new @attr.merge :url => invalid_url
        invalid_url_company.should_not be_valid
      end
    end
    
    it 'should accept valid URLs' do
      valid_urls = ['http://www.engaccino.com',
                    'https://engaccino.com',
                    'https://dom.engaccino.com',
                    'http://franck.engaccino.com',
                    'http://www.engaccino.co.uk',
                    'https://dom.engaccino.com.hk',
                    'http://engaccino.me',
                    'http://www.engaccino.ly',
                    'http://fr.engaccino/users/1/edit' ]
      valid_urls.each do |valid_url|
        valid_url_company = Company.new @attr.merge :url => valid_url
        valid_url_company.should be_valid
      end
    end
    
    it 'should accept empty zip codes' do
      empty_zip_company = Company.new @attr.merge :zip => ''
      empty_zip_company.should be_valid
    end
    
    it 'should reject too long zip codes' do
      too_long_zip = 'a' * 11
      too_long_zip_company = Company.new @attr.merge :zip => too_long_zip
      too_long_zip_company.should_not be_valid
    end
    
    it 'should accept empty abouts' do
      empty_about_company = Company.new @attr.merge :about => ''
      empty_about_company.should be_valid
    end
      
    it 'should reject too short abouts' do
      too_short_about = 'a' * 19
      too_short_about_company = Company.new @attr.merge :about => too_short_about
      too_short_about_company.should_not be_valid
    end
    
    it 'should reject too long abouts' do
      too_long_about = 'a' * 161
      too_long_about_company = Company.new @attr.merge :about => too_long_about
      too_long_about_company.should_not be_valid
    end
    
    describe 'no_about? method' do
      
      it 'should exist' do
        @company.should respond_to :no_about?
      end
      
      it "should be true when the company doesn't have an about" do
        no_about_company = Company.new @attr.merge :about => ''
        no_about_company.no_about?.should be_true
      end
      
      it "should be false when the company has an about" do
        about_company = Company.new @attr.merge :about => 'Loremememememem ipsumumumumumumumumumumumum'
        about_company.no_about?.should be_false
      end
    end
  end
end

# == Schema Information
#
# Table name: companies
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  address    :string(255)
#  city       :string(255)
#  country    :string(255)
#  phone      :string(255)
#  email      :string(255)
#  url        :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  image      :string(255)
#  zip        :string(255)
#  about      :string(255)
#

