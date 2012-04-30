require 'spec_helper'

describe Company do

  before :each do
    @attr = { :name => 'Engaccino', :address => 'Rochussenstraat 243b', :zip => '3021 NV', :city => 'Rotterdam', :country => 'Netherlands', :phone => '+31 6 00000000', :email => 'info@engaccino.com', :url => 'http://www.engaccino.com', :recruiter_agency => false }  
    @candidate  = Factory :candidate
    @company    = Factory :company
    @recruiter  = Factory :recruiter,  :company => @company
    @experience = Factory :experience, :candidate => @candidate, :company => @company
  end
  
  it 'should create a new instance given valid attributes' do
    Company.create!(@attr).should be_valid
  end
  
  describe 'experiences associations' do
    
    it { @company.should respond_to :experiences }
    
    it 'should destroy associated experiences' do
      @company.destroy
      Experience.find_by_id(@experience.id).should be_nil
    end    
  end
  
  describe 'candidates associations' do
    
    it { @company.should respond_to :candidates }
    
    it 'should not destroy associated candidates' do
      @company.destroy
      Candidate.find_by_id(@candidate.id).should_not be_nil
    end    
  end
  
  describe 'recruiters associations' do
    
    it { @company.should respond_to :candidates }
    
    it 'should not destroy associated recruiters' do
      @company.destroy
      Recruiter.find_by_id(@recruiter.id).should_not be_nil
    end    
  end
  
  describe 'validations' do
    
    before :all do
      @country = { :invalid => ['SAVOIE', 'Rotterdam', '6552$%##', '__pouet_' ], :valid => Country.all.collect { |c| c[0] } }
      @url     = { :invalid => ['invalid_url', 'engaccino.com', 'pouetpouetpouet', 'http:www.engaccino.com', 'http//engaccino.com', 'http/ccino.co', 'htp://ccino.me', 'http:/www.engaccino.com', 'http://j ai des espaces. fr'],
                   :valid => ['http://www.engaccino.com', 'https://engaccino.com', 'https://dom.engaccino.com', 'http://franck.engaccino.com', 'http://www.engaccino.co.uk', 'https://dom.engaccino.com.hk', 'http://engaccino.me', 'http://www.engaccino.ly', 'http://fr.engaccino/users/1/edit'] }
      @email   = { :invalid => ['invalid_email','invalid@example','invalid@user@example.com','inv,alide@'], :valid => ['valid_email@example.com', 'valid@example.co.kr', 'vu@example.us'] }
      @phone   = { :invalid => ['06 78 45 91 22', '0033 5 84 92 01 11', '+44 57', '41 (0) 456546456', '+1 98765432187898798798765434423534'], :valid => ['+31 6 31912261', '+33 4 76 30 49 76', '+31 631278086'] }
    end
    
    it { should validate_presence_of :name }
    it { should ensure_length_of(:name).is_at_most 80 }

    it { should_not validate_presence_of :city }
    it { should ensure_length_of(:city).is_at_most 80 }
    
    it { should_not validate_presence_of :country }
    it { should validate_format_of(:country).not_with(@country[:invalid]).with_message(I18n.t('activerecord.errors.messages.inclusion')) }
    it { should validate_format_of(:country).with @country[:valid] }
    
    it { should_not validate_presence_of :address }
    it { should ensure_length_of(:address).is_at_most 160 }

    it { should_not validate_presence_of :about }
    it { should ensure_length_of(:about).is_at_least(20).is_at_most 160 }
    
    it { should_not validate_presence_of :url }
    it { should validate_format_of(:url).not_with(@url[:invalid]).with_message(I18n.t('activerecord.errors.messages.url_format')) }
    it { should validate_format_of(:url).with @url[:valid] }
    
    it { should_not validate_presence_of :email }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_format_of(:email).not_with(@email[:invalid]).with_message(I18n.t('activerecord.errors.messages.email_format')) }
    it { should validate_format_of(:email).with @email[:valid] }
    
    it { should_not validate_presence_of :phone }
    it { should validate_format_of(:phone).not_with(@phone[:invalid]).with_message(I18n.t('activerecord.errors.messages.phone_format')) }
    it { should validate_format_of(:phone).with @phone[:valid] }
    
    it { should_not validate_presence_of :zip }
    it { should ensure_length_of(:zip).is_at_most 10 }
    
    it { should_not validate_presence_of :recruiter_agency }
  end
  
  describe 'no_about? method' do
    
    it { @company.should respond_to :no_about? }
    
    it "should be true for companies without an about" do
      Company.new(@attr.merge(:about => '')).no_about?.should be_true
    end
    
    it "should be false for companies with an about" do
      Company.new(@attr.merge(:about => 'Loremememememem ipsumumumumumumumumumumumum')).no_about?.should be_false
    end
  end
  
  describe 'no_contact_info? method' do
    
    it { @company.should respond_to :no_contact_info? }
    
    it "should be true for companies without any contact information" do
      Company.new(@attr.merge(:url => '', :email => '', :phone => '')).no_contact_info?.should be_true
    end
    
    it "should be false for companies with one or more contact methods (url, email or phone)" do
      Company.new(@attr).no_contact_info?.should be_false
      Company.new(@attr.merge(:url => '')).no_contact_info?.should be_false
      Company.new(@attr.merge(:email => '')).no_contact_info?.should be_false
      Company.new(@attr.merge(:phone => '')).no_contact_info?.should be_false
      Company.new(@attr.merge(:url => '', :email => '')).no_contact_info?.should be_false
      Company.new(@attr.merge(:phone => '', :email => '')).no_contact_info?.should be_false
      Company.new(@attr.merge(:url => '', :phone => '')).no_contact_info?.should be_false
    end
  end
end

# == Schema Information
#
# Table name: companies
#
#  id               :integer(4)      not null, primary key
#  name             :string(255)
#  address          :string(255)
#  city             :string(255)
#  country          :string(255)
#  phone            :string(255)
#  email            :string(255)
#  url              :string(255)
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#  image            :string(255)
#  zip              :string(255)
#  about            :string(255)
#  recruiter_agency :boolean(1)      default(FALSE)
#