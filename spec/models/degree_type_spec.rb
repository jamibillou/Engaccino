require 'spec_helper'

describe DegreeType do

  before :each do
    @attr        = { :label => 'IUT' }
    @candidate   = Factory :candidate
    @degree_type = Factory :degree_type
    @degree      = Factory :degree, :degree_type => @degree_type
    @school      = Factory :school
    @education   = Factory :education, :candidate => @candidate, :school => @school, :degree => @degree
  end

  it 'should create an instance given valid attributes' do
    DegreeType.new(@attr).should be_valid
  end
  
  describe 'degree associations' do
    
    it { @degree_type.should respond_to :degrees }
    
    it 'should not destroy associated degrees' do
      @degree_type.destroy
      Degree.find_by_id(@degree.id).should_not be_nil
    end
  end
  
  describe 'educations associations' do
    
    it { @degree_type.should respond_to :educations }
    
    it 'should not destroy associated educations' do
      @degree_type.destroy
      Education.find_by_id(@education.id).should_not be_nil
    end
  end

  describe 'validations' do
    it { should validate_presence_of :label }
    it { should ensure_length_of(:label).is_at_most 30 }
  end
end

# == Schema Information
#
# Table name: degree_types
#
#  id         :integer(4)      not null, primary key
#  label      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

