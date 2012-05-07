require 'spec_helper'

describe Degree do

  before :each do
    @attr        = { :label => 'Marketing Management' }
    @degree_type = Factory :degree_type
    @degree      = Factory :degree, :degree_type => @degree_type
    @school      = Factory :school
    @candidate   = Factory :candidate
    @education   = Factory :education, :degree => @degree, :candidate => @candidate, :school => @school
  end

  it 'should create an instance given valid attributes' do
    degree = Degree.new @attr ; degree.degree_type = @degree_type
    degree.should be_valid
  end
  
  describe 'degree type associations' do
    
    it { @degree.should respond_to :degree_type }
    
    it 'should not be valid without a degree type' do
      Degree.new(@attr).should_not be_valid
    end
    
    it 'should have the right associated degree_type' do
      @degree.degree_type_id.should == @degree_type.id
      @degree.degree_type.should    == @degree_type
    end    
  end
  
  describe 'educations associations' do
    
    it { @degree.should respond_to :educations }
    
    it 'should destroy associated educations' do
      @degree.destroy
      Education.find_by_id(@education.id).should be_nil
    end
  end
  
  describe 'schools associations' do
    
    it { @degree.should respond_to :schools }
    
    it 'should not destroy associated schools' do
      @degree.destroy
      School.find_by_id(@school.id).should_not be_nil
    end    
  end
  
  describe 'candidates associations' do
    
    it { @degree.should respond_to :candidates }
    
    it 'should not destroy associated candidates' do
      @degree.destroy
      Candidate.find_by_id(@candidate.id).should_not be_nil
    end    
  end
  
  describe 'validations' do
    it { should validate_presence_of :degree_type }
    it { should validate_presence_of :label }
    it { should ensure_length_of(:label).is_at_most 150 }
  end
end

# == Schema Information
#
# Table name: degrees
#
#  id             :integer(4)      not null, primary key
#  label          :string(255)
#  degree_type_id :integer(4)
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

