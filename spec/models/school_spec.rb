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
    School.create(@attr).should be_valid
  end
  
  describe 'educations associations' do
    
    it { @school.should respond_to :educations }
    
    it 'should destroy associated educations' do
      @school.destroy
      Education.find_by_id(@education.id).should be_nil
    end    
  end
  
  describe 'degrees associations' do
    
    it { @school.should respond_to :degrees }
    
    it 'should not destroy associated degrees' do
      @school.destroy
      Degree.find_by_id(@degree.id).should_not be_nil
    end    
  end
  
  describe 'candidates associations' do
    
    it { @school.should respond_to :candidates }
    
    it 'should not destroy associated candidates' do
      @school.destroy
      Candidate.find_by_id(@candidate.id).should_not be_nil
    end    
  end

  describe 'validations' do
    
    before :all do
      @country = { :invalid => ['SAVOIE', 'Rotterdam', '6552$%##', '__pouet_' ], :valid => Country.all.collect { |c| c[0] } }
    end
    
    it { should validate_presence_of :name }
    it { should ensure_length_of(:name).is_at_most 200 }
        
    it { should_not validate_presence_of :city }
    it { should ensure_length_of(:city).is_at_most 80 }
    
    it { should_not validate_presence_of :country }
    it { should validate_format_of(:country).not_with(@country[:invalid]).with_message(I18n.t('activerecord.errors.messages.inclusion')) }
    it { should validate_format_of(:country).with @country[:valid] }
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
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

