require 'spec_helper'

describe School do

  before :each do
    @attr      = { :name => 'Imperial College', :city => 'London', :country  => 'United Kingdom' }
    @school    = Factory :school
    @candidate = Factory :candidate
    @degree    = Factory :degree
    @education = Factory :education, :degree => @degree, :candidate => @candidate, :school => @school
  end

  it 'should create an instance given valid attributes' do
    school = School.create! @attr
    school.should be_valid
  end
  
  describe 'educations associations' do
    
    it 'should have an educations attribute' do
      @school.should respond_to :educations
    end
    
    it 'should destroy associated educations' do
      @school.destroy
      Education.find_by_id(@education.id).should be_nil
    end    
  end
  
  describe 'degrees associations' do
    
    it 'should have a degrees attribute' do
      @school.should respond_to :degrees
    end
    
    it 'should not destroy associated degrees' do
      @school.destroy
      Degree.find_by_id(@degree.id).should_not be_nil
    end    
  end
  
  describe 'candidates associations' do
    
    it 'should have a candidates attribute' do
      @school.should respond_to :candidates
    end
    
    it 'should not destroy associated candidates' do
      @school.destroy
      Candidate.find_by_id(@candidate.id).should_not be_nil
    end    
  end

  describe 'validations' do
    
    it 'should require a name' do
      invalid_school = School.new @attr.merge :name => ''
      invalid_school.should_not be_valid
    end
    
    it 'should reject too long names' do
      long_name = 'a' * 201
      long_name_school = School.new @attr.merge :name => long_name
      long_name_school.should_not be_valid
    end
    
    it 'should accept empty cities' do
      empty_city_school = School.new @attr.merge :city => ''
      empty_city_school.should be_valid
    end
    
    it 'should reject too long cities' do
      long_city = 'a' * 81
      long_city_school = School.new @attr.merge :city => long_city
      long_city_school.should_not be_valid
    end
    
    it 'should accept empty countries' do
      empty_country_school = School.new @attr.merge :country => ''
      empty_country_school.should be_valid
    end
    
    it 'should reject invalid countries' do
      invalid_countries = [ 'SAVOIE', 'Rotterdam', '6552$%##', '__pouet_' ]
      invalid_countries.each do |invalid_country|
        invalid_country_school = School.new @attr.merge :country => invalid_country
        invalid_country_school.should_not be_valid
      end
    end
    
    it 'should accept valid countries' do
      valid_countries = Country.all.collect { |c| c[0] }
      valid_countries.each do |valid_country|
        valid_country_school = School.new @attr.merge :country => valid_country
        valid_country_school.should be_valid
      end
    end
  end
end

# == Schema Information
#
# Table name: schools
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  city       :string(255)
#  country    :string(255)
#  created_at :datetime
#  updated_at :datetime
#