require 'spec_helper'

describe Recruiter do
  
  before :each do
    @company = Factory :company
    @recruiter = Factory :recruiter, :company => @company
    @attr = { :first_name    => 'Juan',           :last_name      => 'Pablo',          :city                  => 'Madrid', :country => 'Spain',
              :nationality   => 'Spain',          :year_of_birth  => 1984,             :phone                 => '+34 6 88888888',
              :email         => 'jp@example.net', :facebook_login => 'jp@example.net', :linkedin_login        => 'jp@example.net',
              :twitter_login => '@j_pablo',       :password       => 'pouetpouet38',   :password_confirmation => 'pouetpouet38',
              :quote         => "I am generally looking for finance professionals but also have opportunities elsewhere through relations." }
  end
  
  describe 'validations' do
    
    it 'should have a quote attribute' do
      @recruiter.should respond_to :quote
    end
    
    it 'should accept empty quotes' do
      empty_quote_recruiter = Recruiter.new @attr.merge :quote => ''
      empty_quote_recruiter.should be_valid
    end
    
    it 'should reject too long quotes' do
      too_long_quote = 'a'*201
      too_long_quote_recruiter = Recruiter.new @attr.merge :quote => too_long_quote
      too_long_quote_recruiter.should_not be_valid
    end
  end
  
  describe 'company associations' do
    
    it 'should have a company attribute' do
      @recruiter.should respond_to :company
    end
    
    it 'should have a the right associated company' do
      @recruiter.company_id.should == @company.id
      @recruiter.company.should    == @company
    end
    
    it 'should not destroy associated companies' do
      @recruiter.destroy
      Company.find_by_id(@company.id).should_not be_nil
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