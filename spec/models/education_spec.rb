require 'spec_helper'

describe Education do
  
  before(:each) do
    @attr = {:description => 'A lot of maths, chemical and a bit of computing sciences',
             :year => 2001}
    @candidate = Factory(:candidate)
    @school = Factory(:school)
    @degree = Factory(:degree)
    @education = Factory(:education, 
                         :degree    => @degree,
                         :candidate => @candidate,
                         :school    => @school)
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
    
    it "should have the right associated school" do
      @education.degree_id.should == @degree.id
      @education.degree.should == @degree
    end
  end

  describe "candidate associations" do
    
    it "should have a candidate attribute" do
      @education.should respond_to(:candidate)
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
    
    it "should not destroy associated degrees" do
      @education.school_id.should == @school.id
      @education.school.should == @school
    end 
  end
  
  describe "attributes validations" do
    
    describe "mandatory attributes" do
      
      it "should require a degree id" do
        @degree.educations.build(@attr).should_not be_valid
      end
      
      it "should require a candidate id" do
        @candidate.educations.build(@attr).should_not be_valid
      end   
    end
    
    describe "optional attributes" do
      
      it "should accept empty descriptions" do
        empty_description_education = Education.new(@attr.merge(:description => ''))
        empty_description_education.degree = @degree
        empty_description_education.school = @school
        empty_description_education.candidate = @candidate
        empty_description_education.should be_valid
      end
      
      it "should reject too long descriptions" do
        long_description = 'a' * 501
        long_description_education = Education.new(@attr.merge(:description => long_description))
        long_description_education.degree = @degree
        long_description_education.candidate = @candidate  
        long_description_education.school = @school
        long_description_education.should_not be_valid
      end
      
      it "should accept empty years" do
        empty_year_education = Education.new(@attr.merge(:year => ''))
        empty_year_education.degree = @degree
        empty_year_education.school = @school
        empty_year_education.candidate = @candidate 
        empty_year_education.should be_valid
      end
      
      it "should accept valid years" do
        valid_years = [ 1995, 2010, 1980, 2000 ]
        valid_years.each do |valid_year|
          education = Education.new(@attr.merge(:year => valid_year))
          education.degree = @degree
          education.school = @school
          education.candidate = @candidate
          education.should be_valid
        end
      end
      
      it "should reject invalid years" do
        invalid_years = [ 'year', 12, Time.now.year+1, 1792 ]
        invalid_years.each do |invalid_year|
          education = Education.new(@attr.merge(:year => invalid_year))
          education.degree = @degree
          education.school = @school
          education.candidate = @candidate
          education.should_not be_valid
        end        
      end
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
#  year         :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

