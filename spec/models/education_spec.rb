require 'spec_helper'

describe Education do
  
  before(:each) do
    @attr = {:description => 'A lot of maths, chemical and a bit of computing sciences',
             :start_month => 9,
             :start_year  => 2003,
             :end_month   => 6,
             :end_year    => 2005}
    @candidate = Factory(:candidate)
    @school    = Factory(:school)
    @degree    = Factory(:degree)
    @education = Factory(:education, :degree => @degree, :candidate => @candidate, :school => @school)
  end
  
  it "should create an instance given valid attributes" do
    education = Education.new(@attr)
    education.degree = @degree
    education.school = @school
    education.candidate = @candidate
    education.save!
    education.should be_valid
  end
  
  describe "degree associations" do
    
    it "should have a degree attribute" do
      @education.should respond_to(:degree)
    end
    
    it "should not be valid without a degree" do
      education_without_degree = Education.new(@attr)
      education_without_degree.school = @school
      education_without_degree.candidate = @candidate
      education_without_degree.should_not be_valid
    end
    
    it "should have the right associated school" do
      @education.degree_id.should == @degree.id
      @education.degree.should == @degree
    end
  end

  describe "candidate associations" do
    
    it "should have a candidate attribute" do
      @education.should respond_to(:candidate)
    end
    
    it "should not be valid without a candidate" do
      education_without_candidate = Education.new(@attr)
      education_without_candidate.school = @school
      education_without_candidate.degree = @degree
      education_without_candidate.should_not be_valid
    end
    
    it "should have the right associated candidate" do
      @education.candidate_id.should == @candidate.id
      @education.candidate.should == @candidate
    end
  end
  
  describe "school associations" do
    
    it "should have a school attribute" do
      @education.should respond_to(:school)
    end
    
    it "should not be valid without a school" do
      education_without_project = Education.new(@attr)
      education_without_project.degree = @degree
      education_without_project.candidate = @candidate
      education_without_project.should_not be_valid      
    end
    
    it "should not destroy associated degrees" do
      @education.school_id.should == @school.id
      @education.school.should == @school
    end 
  end
  
  describe "validations" do
          
    it "should require a degree" do
      education = @candidate.educations.build(@attr)
      education.school = @school
      education.should_not be_valid
    end
    
    it "should require a candidate" do
      education = @degree.educations.build(@attr)
      education.school = @school
      education.should_not be_valid
    end
    
    it "should require a school" do
      education = @candidate.educations.build(@attr)
      education.degree = @degree
      education.should_not be_valid
    end   
      
    it "should accept empty descriptions" do
      empty_description_education = Education.new(@attr.merge(:description => ''))
      empty_description_education.degree = @degree
      empty_description_education.school = @school
      empty_description_education.candidate = @candidate
      empty_description_education.should be_valid
    end
    
    it "should reject too short descriptions" do
      short_description = 'a'*19
      short_description_education = Education.new(@attr.merge(:description => short_description))
      short_description_education.degree = @degree
      short_description_education.candidate = @candidate  
      short_description_education.school = @school
      short_description_education.should_not be_valid
    end
    
    it "should reject too long descriptions" do
      long_description = 'a' * 301
      long_description_education = Education.new(@attr.merge(:description => long_description))
      long_description_education.degree = @degree
      long_description_education.candidate = @candidate  
      long_description_education.school = @school
      long_description_education.should_not be_valid
    end
    
    it "should require a start year" do
      education = Education.new(@attr.merge(:start_year => ''))
      education.candidate = @candidate
      education.school = @school
      education.degree = @degree
      education.should_not be_valid
    end
    
    it "should reject invalid start years" do
      invalid_start_years = [ 'year', 12, Time.now.year+1, 1792 ]
      invalid_start_years.each do |invalid_start_year|
        education = Education.new(@attr.merge(:start_year => invalid_start_year))
        education.candidate = @candidate
        education.school = @school
        education.degree = @degree
        education.should_not be_valid
      end
    end
    
    it "should accept valid start years" do
      valid_start_years = [ 1995, 1923, 1980, 2000 ]
      valid_start_years.each do |valid_start_year|
        education = Education.new(@attr.merge(:start_year => valid_start_year))
        education.candidate = @candidate
        education.school = @school
        education.degree = @degree
        education.should be_valid
      end
    end
    
    it "should require an end year" do
      education = Education.new(@attr.merge(:end_year => ''))
      education.candidate = @candidate
      education.school = @school
      education.degree = @degree
      education.should_not be_valid
    end
    
    it "should reject invalid end years" do
      invalid_end_years = [ 'year', 12, Time.now.year+1, 1792 ]
      invalid_end_years.each do |invalid_end_year|
        education = Education.new(@attr.merge(:end_year => invalid_end_year))
        education.candidate = @candidate
        education.school = @school
        education.degree = @degree
        education.should_not be_valid
      end
    end
    
    it "should accept valid end years" do
      valid_end_years = [ 1995, 2010, 1980, 2000 ]
      valid_end_years.each do |valid_end_year|
        education = Education.new(@attr.merge(:start_year => valid_end_year-1, :end_year => valid_end_year))
        education.candidate = @candidate
        education.school = @school
        education.degree = @degree
        education.should be_valid
      end
    end
    
    it "should reject start years greater than end years" do
      greater_start_year_education = Education.new(@attr.merge(:start_year => 2010, :start_month => 1, :end_year => 2009, :end_month => 10))
      greater_start_year_education.candidate = @candidate
      greater_start_year_education.school = @school
      greater_start_year_education.degree = @degree
      greater_start_year_education.should_not be_valid
    end
  
    it "should require a start month" do
      education = Education.new(@attr.merge(:start_month => ''))
      education.candidate = @candidate
      education.school = @school
      education.degree = @degree
      education.should_not be_valid
    end
    
    it "should reject invalid start months" do
      invalid_start_months = [ 'march', 13, 0, '*&^%$#@' ]
      invalid_start_months.each do |invalid_start_month|
        education = Education.new(@attr.merge(:start_month => invalid_start_month))
        education.candidate = @candidate
        education.school = @school
        education.degree = @degree
        education.should_not be_valid
      end
    end
    
    it "should accept valid start months" do
      valid_start_months = [ 1, 3, 9, 12 ]
      valid_start_months.each do |valid_start_month|
        education = Education.new(@attr.merge(:start_month => valid_start_month))
        education.candidate = @candidate
        education.school = @school
        education.degree = @degree
        education.should be_valid
      end
    end
    
    it "should require an end month" do
      education = Education.new(@attr.merge(:end_month => ''))
      education.candidate = @candidate
      education.school = @school
      education.degree = @degree
      education.should_not be_valid
    end
    
    it "should reject invalid end months" do
      invalid_end_months = [ 'march', 13, 0, '*&^%$#@' ]
      invalid_end_months.each do |invalid_end_month|
        education = Education.new(@attr.merge(:end_month => invalid_end_month))
        education.candidate = @candidate
        education.school = @school
        education.degree = @degree
        education.should_not be_valid
      end
    end
    
    it "should accept valid end months" do
      valid_end_months = [ 1, 3, 9, 12 ]
      valid_end_months.each do |valid_end_month|
        education = Education.new(@attr.merge(:end_month => valid_end_month))
        education.candidate = @candidate
        education.school = @school
        education.degree = @degree
        education.should be_valid
      end
    end
    
    it "should reject start months greater than end months when start and end years are the same" do
      greater_start_month_education = Education.new(@attr.merge(:start_year => 2009, :start_month => 5, :end_year => 2009, :end_month => 3))
      greater_start_month_education.candidate = @candidate
      greater_start_month_education.school = @school
      greater_start_month_education.degree = @degree
      greater_start_month_education.should_not be_valid
    end
    
    it "should accept start months greater than end months when start and end years are different" do
      greater_start_month_education = Education.new(@attr)
      greater_start_month_education.candidate = @candidate
      greater_start_month_education.school = @school
      greater_start_month_education.degree = @degree
      greater_start_month_education.should be_valid
    end
  end
  
  describe "main attribute" do
    
    it "should exist" do
      @education.should respond_to(:main)
    end
    
    it "should be false by default" do
      @education.should_not be_main
    end
    
    it "should be convertible to true" do
      @education.toggle!(:main)
      @education.should be_main
    end
  end
  
  describe "duration method" do
    
    it "should exist" do
      @education.should respond_to(:duration)
    end
    
    it "should calculate the right number of years between the dates" do
      @education.duration.truncate.should == 2
      @education.duration.round.should == 3
    end
    
    it "should calculate the right number of months between the dates" do
      (@education.duration * 12).round.should == 34
    end
  end
  
  describe "yrs_after_first_event method" do
    
    it "should exist" do
      @education.should respond_to(:yrs_after_first_event)
    end
    
    it "should be 0 if the education is the first event" do
      @education.yrs_after_first_event.should == 0
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
#  main         :boolean(1)      default(FALSE)
#

