require 'spec_helper'

describe Experience do

  before(:each) do
    @attr = { :role => 'UX Designer',
              :start_month => 7,
              :start_year => 2009,
              :end_month => 2,
              :end_year => 2011,
              :description => 'Designed web-apps mostly, a bit of mobile work as well.'
            }
    @candidate = Factory(:candidate) 
    @experience = Factory(:experience, :candidate => @candidate)  
  end
  
  it "should create a new instance given valid attributes" do
    experience = @candidate.experiences.create!(@attr)
    experience.should be_valid
  end
  
  describe "candidate association" do
  
    before(:each) do
      @experience = @candidate.experiences.create!(@attr)
    end
    
    it "should have a candidate attribute" do
      @experience.should respond_to(:candidate)
    end
    
    it "should have the right associated user" do
      @experience.candidate_id.should == @candidate.id
      @experience.candidate.should == @candidate
    end
  end
  
  describe "validations of" do
    
    describe "mandatory attributes" do
    
      it "should require a candidate id" do
        Experience.new(@attr).should_not be_valid
      end
      
      it "should require a role" do
        @candidate.experiences.build(@attr.merge(:role => '')).should_not be_valid
      end
      
      it "should reject too short roles" do
        too_short_role = 'a'*2
        @candidate.experiences.build(@attr.merge(:role => too_short_role)).should_not be_valid
      end
      
      it "should reject too long roles" do
        too_long_role = 'a'*81
        @candidate.experiences.build(@attr.merge(:role => too_long_role)).should_not be_valid
      end
      
      it "should require a start year" do
        @candidate.experiences.build(@attr.merge(:start_year => '')).should_not be_valid
      end
      
      it "should reject invalid start years" do
        invalid_start_years = [ 'year', 12, Time.now.year+1, 1792 ]
        invalid_start_years.each do |invalid_start_year|
          @candidate.experiences.build(@attr.merge(:start_year => invalid_start_year)).should_not be_valid
        end
      end
      
      it "should accept valid start years" do
        valid_start_years = [ 1995, 2010, 1980, 2000 ]
        valid_start_years.each do |valid_start_year|
          @candidate.experiences.build(@attr.merge(:start_year => valid_start_year)).should be_valid
        end
      end
      
      it "should require an end year" do
        @candidate.experiences.build(@attr.merge(:end_year => '')).should_not be_valid
      end
      
      it "should reject invalid end years" do
        invalid_end_years = [ 'year', 12, Time.now.year+1, 1792 ]
        invalid_end_years.each do |invalid_end_year|
          @candidate.experiences.build(@attr.merge(:end_year => invalid_end_year)).should_not be_valid
        end
      end
      
      it "should accept valid end years" do
        valid_end_years = [ 1995, 2010, 1980, 2000 ]
        valid_end_years.each do |valid_end_year|
          @candidate.experiences.build(@attr.merge(:end_year => valid_end_year)).should be_valid
        end
      end
    end
    
    describe "optional attributes" do
    
      it "should accept empty start months" do
        @candidate.experiences.build(@attr.merge(:start_month => '')).should be_valid
      end
      
      it "should reject invalid start months" do
        invalid_start_months = [ 'march', 13, 0, '*&^%$#@' ]
        invalid_start_months.each do |invalid_start_month|
          @candidate.experiences.build(@attr.merge(:start_month => invalid_start_month)).should_not be_valid
        end
      end
      
      it "should accept valid start months" do
        valid_start_months = [ 1, 3, 9, 12 ]
        valid_start_months.each do |valid_start_month|
          @candidate.experiences.build(@attr.merge(:start_month => valid_start_month)).should be_valid
        end
      end
      
      it "should accept empty end months" do
        @candidate.experiences.build(@attr.merge(:end_month => '')).should be_valid
      end
      
      it "should reject invalid end months" do
        invalid_end_months = [ 'march', 13, 0, '*&^%$#@' ]
        invalid_end_months.each do |invalid_end_month|
          @candidate.experiences.build(@attr.merge(:end_month => invalid_end_month)).should_not be_valid
        end
      end
      
      it "should accept valid end months" do
        valid_end_months = [ 1, 3, 9, 12 ]
        valid_end_months.each do |valid_end_month|
          @candidate.experiences.build(@attr.merge(:end_month => valid_end_month)).should be_valid
        end
      end
      
      it "should accept empty descriptions" do
        @candidate.experiences.build(@attr.merge(:description => '')).should be_valid
      end
      
      it "should reject too short descriptions" do
        too_short_description = 'a'*19
        @candidate.experiences.build(@attr.merge(:description => too_short_description)).should_not be_valid
      end
      
      it "should reject too long descriptions" do
        too_long_description = 'a'*161
        @candidate.experiences.build(@attr.merge(:description => too_long_description)).should_not be_valid
      end
    end
  end
end

# == Schema Information
#
# Table name: experiences
#
#  id           :integer(4)      not null, primary key
#  candidate_id :integer(4)
#  company_id   :integer(4)
#  start_month  :integer(4)
#  start_year   :integer(4)
#  end_month    :integer(4)
#  end_year     :integer(4)
#  description  :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  role         :string(255)
#

