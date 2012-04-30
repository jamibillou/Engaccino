require 'spec_helper'

describe Education do
  
  before :each do
    @attr      = { :description => 'A lot of maths, chemistry and a bit of computier sciences', :start_month => 9, :start_year => 2003, :end_month => 6, :end_year => 2005 }
    @candidate = Factory :candidate
    @school    = Factory :school
    @degree    = Factory :degree
    @education = Factory :education, :degree => @degree, :candidate => @candidate, :school => @school
  end
  
  it 'should create an instance given valid attributes' do
    education = Education.new @attr ; education.degree = @degree ; education.school = @school ; education.candidate = @candidate
    education.should be_valid
  end
  
  describe 'degree associations' do
    
    it { @education.should respond_to :degree }
        
    it 'should not be valid without a degree' do
      education_without_degree = Education.new @attr ; education_without_degree.school = @school ; education_without_degree.candidate = @candidate
      education_without_degree.should_not be_valid
    end
    
    it 'should have the right associated degree' do
      @education.degree_id.should == @degree.id
      @education.degree.should    == @degree
    end
    
    it 'should not destroy associated degrees' do
      @education.destroy
      Degree.find_by_id(@degree.id).should_not be_nil
    end
  end

  describe 'candidate associations' do
    
    it { @education.should respond_to :candidate }
    
    it 'should not be valid without a candidate' do
      education_without_candidate = Education.new @attr ; education_without_candidate.school = @school ; education_without_candidate.degree = @degree
      education_without_candidate.should_not be_valid
    end
    
    it 'should have the right associated candidate' do
      @education.candidate_id.should == @candidate.id
      @education.candidate.should    == @candidate
    end
    
    it 'should not destroy associated candidates' do
      @education.destroy
      Candidate.find_by_id(@candidate.id).should_not be_nil
    end
  end
  
  describe 'school associations' do
    
    it { @education.should respond_to :school }
    
    it 'should not be valid without a school' do
      education_without_project = Education.new @attr ; education_without_project.degree = @degree ; education_without_project.candidate = @candidate
      education_without_project.should_not be_valid      
    end
    
    it 'should not have the right associated school' do
      @education.school_id.should == @school.id
      @education.school.should    == @school
    end
    
    it 'should not destroy associated schools' do
      @education.destroy
      Candidate.find_by_id(@candidate.id).should_not be_nil
    end
  end
  
  describe 'validations' do
          
    it { should validate_presence_of :degree }
    it { should validate_presence_of :candidate_id }
    it { should validate_presence_of :school }
    
    it { should_not validate_presence_of :description }
    it { should ensure_length_of(:description).is_at_least(20).is_at_most 300 }
    
    it { should validate_presence_of :start_month }
    it { should ensure_inclusion_of(:start_month).in_range 1..12 }
    
    it { should validate_presence_of :start_year }
    it { should ensure_inclusion_of(:start_year).in_range 100.years.ago.year..Time.now.year }
    
    it { should validate_presence_of :end_month }
    it { should ensure_inclusion_of(:end_month).in_range 1..12 }
    
    it { should validate_presence_of :end_year }
    it { should ensure_inclusion_of(:end_year).in_range 100.years.ago.year..Time.now.year }
    
    it 'should reject start years greater than end years' do
      incoherent_education = Education.new :start_year => 2010, :start_month => 1, :end_year => 2009, :end_month => 10
      incoherent_education.candidate = @candidate ; incoherent_education.degree = @degree ; incoherent_education.school = @school
      incoherent_education.should_not be_valid
    end
    
    context 'start and end years are the same' do
      
      it 'should reject start months greater than end months' do
        incoherent_education = Education.new :start_year => 2009, :start_month => 5, :end_year => 2009, :end_month => 3
        incoherent_education.candidate = @candidate ; incoherent_education.degree = @degree ; incoherent_education.school = @school
        incoherent_education.should_not be_valid
      end
      
      it 'should accept start months lower than end months' do
        coherent_education = Factory :education, :start_year => 2009, :start_month => 5, :end_year => 2009, :end_month => 10, :candidate => @candidate
        coherent_education.should be_valid
      end
    end
    
    context 'start and end years are different' do
      it 'should accept start months greater than end months' do
        coherent_education = Factory :education, @attr.merge(:candidate => @candidate)
        coherent_education.should be_valid
      end
    end
  end
  
  describe 'main attribute' do
    it { @education.should respond_to :main }
  end
  
  describe 'duration method' do
    
    it { @education.should respond_to :duration }
    
    it 'should calculate the right number of years between the dates' do
      @education.duration.truncate.should == 2
      @education.duration.round.should == 3
    end
    
    it 'should calculate the right number of months between the dates' do
      (@education.duration * 12).round.should == 34
    end
  end
  
  describe 'yrs_after_first_event method' do
    
    it { @education.should respond_to :yrs_after_first_event }
    
    it 'should be 0 if the education is the first event' do
      @education.yrs_after_first_event.should == 0
    end
    
    it 'be the number of years between the the first event and the education' do
      Factory :education, :start_month => 1, :start_year => 1990, :end_month => 2, :end_year => 1992, :candidate => @candidate
      @education.yrs_after_first_event.floor.should == 15
    end
  end
end

# == Schema Information
#
# Table name: educations
#
#  id           :integer(4)      not null, primary key
#  degree_id    :integer(4)
#  school_id    :integer(4)
#  candidate_id :integer(4)
#  description  :string(255)
#  start_month  :integer(4)
#  start_year   :integer(4)
#  end_month    :integer(4)
#  end_year     :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#