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
    @candidate  = Factory(:candidate)
    @company    = Factory(:company)
    @experience = Factory(:experience, :candidate => @candidate, :company => @company)
  end
  
  it "should create a new instance given valid attributes" do
    experience = Experience.new(@attr)
    experience.candidate = @candidate
    experience.company = @company
    experience.save!
    experience.should be_valid
  end
  
  describe "candidate associations" do
    
    it "should have a candidate attribute" do
      @experience.should respond_to(:candidate)
    end
    
    it "should not be valid without a candidate" do
      experience_without_candidate = Experience.new(@attr)
      experience_without_candidate.company = @company
      experience_without_candidate.should_not be_valid
    end
    
    it "should have the right associated candidate" do
      @experience.candidate_id.should == @candidate.id
      @experience.candidate.should == @candidate
    end
  end
  
  describe "company associations" do
    
    it "should have a company attribute" do
      @experience.should respond_to(:company)
    end
    
    it "should not be valid without a company" do
      experience_without_company = Experience.new(@attr)
      experience_without_company.candidate = @candidate
      experience_without_company.should_not be_valid
    end
    
    it "should have the right associated company" do
      @experience.company_id.should == @company.id
      @experience.company.should == @company
    end
  end
  
  describe "validations" do
    
    it "should require a candidate" do
      @company.experiences.build(@attr).should_not be_valid
    end
    
    it "should require a company" do
      @candidate.experiences.build(@attr).should_not be_valid
    end
    
    it "should require a role" do
      experience = Experience.new(@attr.merge(:role => ''))
      experience.candidate = @candidate
      experience.company = @company
      experience.should_not be_valid
    end
    
    it "should reject too short roles" do
      too_short_role = 'a'*2
      experience = Experience.new(@attr.merge(:role => too_short_role))
      experience.candidate = @candidate
      experience.company = @company
      experience.should_not be_valid
    end
    
    it "should reject too long roles" do
      too_long_role = 'a'*81
      experience = Experience.new(@attr.merge(:role => too_long_role))
      experience.candidate = @candidate
      experience.company = @company
      experience.should_not be_valid
    end
    
    it "should require a start month" do
      experience = Experience.new(@attr.merge(:start_month => ''))
      experience.candidate = @candidate
      experience.company = @company
      experience.should_not be_valid
    end
    
    it "should reject invalid start months" do
      invalid_start_months = [ 'march', 13, 0, '*&^%$#@' ]
      invalid_start_months.each do |invalid_start_month|
        experience = Experience.new(@attr.merge(:start_month => invalid_start_month))
        experience.candidate = @candidate
        experience.company = @company
        experience.should_not be_valid
      end
    end
    
    it "should accept valid start months" do
      valid_start_months = [ 1, 3, 9, 12 ]
      valid_start_months.each do |valid_start_month|
        experience = Experience.new(@attr.merge(:start_month => valid_start_month))
        experience.candidate = @candidate
        experience.company = @company
        experience.should be_valid
      end
    end
    
    it "should require a start year" do
      experience = Experience.new(@attr.merge(:start_year => ''))
      experience.candidate = @candidate
      experience.company = @company
      experience.should_not be_valid
    end
    
    it "should reject invalid start years" do
      invalid_start_years = [ 'year', 12, Time.now.year+1, 1792 ]
      invalid_start_years.each do |invalid_start_year|
        experience = Experience.new(@attr.merge(:start_year => invalid_start_year))
        experience.candidate = @candidate
        experience.company = @company
        experience.should_not be_valid
      end
    end
    
    it "should accept valid start years" do
      valid_start_years = [ 1995, 2010, 1980, 2000 ]
      valid_start_years.each do |valid_start_year|
        experience = Experience.new(@attr.merge(:start_year => valid_start_year))
        experience.candidate = @candidate
        experience.company = @company
        experience.should be_valid
      end
    end
    
    describe "when current" do
    
      it "should require neither end month nor end year" do
        experience = Experience.new(@attr.merge(:end_month => '', :end_year => ''))
        experience.candidate = @candidate
        experience.company = @company
        experience.toggle!(:current)
        experience.should be_valid
      end
    end
    
    describe "when not current" do
    
      it "should require an end year" do
        experience = Experience.new(@attr.merge(:end_year => ''))
        experience.candidate = @candidate
        experience.company = @company
        experience.should_not be_valid
      end
      
      it "should reject invalid end years" do
        invalid_end_years = [ 'year', 12, Time.now.year+1, 1792 ]
        invalid_end_years.each do |invalid_end_year|
          experience = Experience.new(@attr.merge(:end_year => invalid_end_year))
          experience.candidate = @candidate
          experience.company = @company
          experience.should_not be_valid
        end
      end
      
      it "should accept valid end years" do
        valid_end_years = [ 1995, 2010, 1980, 2000 ]
        valid_end_years.each do |valid_end_year|
          experience = Experience.new(@attr.merge(:start_year => valid_end_year-1, :end_year => valid_end_year))
          experience.candidate = @candidate
          experience.company = @company
          experience.should be_valid
        end
      end
      
      it "should reject start years greater than end years" do
        experience = Experience.new(@attr.merge(:start_year => 2010, :start_month => 5, :end_year => 2009, :end_month => 3))
        experience.candidate = @candidate
        experience.company = @company
        experience.should_not be_valid
      end
      
      it "should require an end month" do
        experience = Experience.new(@attr.merge(:end_month => ''))
        experience.candidate = @candidate
        experience.company = @company
        experience.should_not be_valid
      end
      
      it "should reject invalid end months" do
        invalid_end_months = [ 'march', 13, 0, '*&^%$#@' ]
        invalid_end_months.each do |invalid_end_month|
          experience = Experience.new(@attr.merge(:end_month => invalid_end_month))
          experience.candidate = @candidate
          experience.company = @company
          experience.should_not be_valid
        end
      end
      
      it "should accept valid end months" do
        valid_end_months = [ 1, 3, 9, 12 ]
        valid_end_months.each do |valid_end_month|
          experience = Experience.new(@attr.merge(:end_month => valid_end_month))
          experience.candidate = @candidate
          experience.company = @company
          experience.should be_valid
        end
      end
      
      it "should reject start months greater than end months when start and end years are the same" do
        experience = Experience.new(@attr.merge(:start_year => 2009, :start_month => 5, :end_year => 2009, :end_month => 3))
        experience.candidate = @candidate
        experience.company = @company
        experience.should_not be_valid
      end
      
      it "should accept start months greater than end months when start and end years are different" do
        experience = Experience.new(@attr)
        experience.candidate = @candidate
        experience.company = @company
        experience.should be_valid
      end
    end
    
    it "should accept empty descriptions" do
      experience = Experience.new(@attr.merge(:description => ''))
      experience.candidate = @candidate
      experience.company = @company
      experience.should be_valid
    end
    
    it "should reject too short descriptions" do
      too_short_description = 'a'*19
      experience = Experience.new(@attr.merge(:description => too_short_description))
      experience.candidate = @candidate
      experience.company = @company
      experience.should_not be_valid
    end
    
    it "should reject too long descriptions" do
      too_long_description = 'a'*301
      experience = Experience.new(@attr.merge(:description => too_long_description))
      experience.candidate = @candidate
      experience.company = @company
      experience.should_not be_valid
    end
  end
  
  describe "current attribute" do
    
    it "should exist" do
      @experience.should respond_to(:current)
    end
    
    it "should be false by default" do
      @experience.current.should be_false
    end
    
    it "should be convertible to true" do
      @experience.toggle!(:current)
      @experience.current.should be_true
    end
  end
  
  describe "duration method" do
    
    it "should exist" do
      @experience.should respond_to(:duration)
    end
    
    it "should be nil if a year or month is missing" do
      Experience.new(@attr.merge(:start_year  => '')).duration.should be_nil
      Experience.new(@attr.merge(:end_year    => '')).duration.should be_nil
      Experience.new(@attr.merge(:start_month => '')).duration.should be_nil
      Experience.new(@attr.merge(:end_month   => '')).duration.should be_nil
    end
    
    it "should calculate the right number of years between the dates" do
      @experience.duration.truncate.should == 5
      @experience.duration.round.should == 6
    end
    
    it "should calculate the right number of months between the dates" do
      (@experience.duration * 12).round.should == 67
    end
  end
  
  describe "yrs_after_first_event method" do
    
    it "should exist" do
      @experience.should respond_to(:yrs_after_first_event)
    end
    
    it "should be nil if a year or month is missing" do
      Experience.new(@attr.merge(:start_year  => '')).yrs_after_first_event.should be_nil
      Experience.new(@attr.merge(:end_year    => '')).yrs_after_first_event.should be_nil
      Experience.new(@attr.merge(:start_month => '')).yrs_after_first_event.should be_nil
      Experience.new(@attr.merge(:end_month   => '')).yrs_after_first_event.should be_nil
    end
    
    it "should be 0 if the experience is the first event" do
      @experience.yrs_after_first_event.should == 0
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
#  current      :boolean(1)      default(FALSE)
#

