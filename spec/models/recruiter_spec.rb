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
