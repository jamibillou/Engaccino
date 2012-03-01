require 'spec_helper'

describe EducationObserver do
  
  before(:each) do
    @candidate  = Factory(:candidate)
    @school     = Factory(:school)
    @degree     = Factory(:degree)
    @education1 = Education.new(:start_month => 1, :start_year => 2000, :end_month => 1, :end_year => 2001)
    @education2 = Education.new(:start_month => 2, :start_year => 2001, :end_month => 2, :end_year => 2002)
    @education3 = Education.new(:start_month => 3, :start_year => 2002, :end_month => 3, :end_year => 2003)
    @education1.candidate = @candidate ; @education1.school = @school ; @education1.degree = @degree
    @education2.candidate = @candidate ; @education2.school = @school ; @education2.degree = @degree
    @education3.candidate = @candidate ; @education3.school = @school ; @education3.degree = @degree
    [ @education1, @education2, @education3 ].each { |education| education.save! }
  end
  
  describe "set_main method" do
  
    it "should set a new education as main if it's the candidate's latest one" do
      education4 = Education.new(:start_month => 4, :start_year => 2003, :end_month => 4, :end_year => 2004)
      education4.candidate = @candidate ; education4.school = @school ; education4.degree = @degree
      education4.save!
      @candidate.main_education.should == education4.id
    end
    
    it "should set an education as main if it was updated to being the candidate's latest one" do
      @education1.update_attributes(:start_month => 5, :start_year => 2004, :end_month => 5, :end_year => 2005)
      @education1.save!
      @candidate.main_education.should == @education1.id
    end
    
    it "should set a candidate's latest education as main if his former main education was updated with dates that make it not being the latest one anymore" do
      Education.find_by_id(@candidate.main_education).update_attributes(:start_month => 12, :start_year => 1998, :end_month => 12, :end_year => 1999)
      @candidate.reload.main_education.should == @candidate.last_education.id
    end
        
    it "should set a candidate's latest education as main if his former main education was deleted" do
      Education.find(@candidate.main_education).destroy
      @candidate.reload.main_education.should == @candidate.last_education.id
    end
  
    it "should set a candidate's main education to nil after he deleted all of them" do
      @candidate.educations.each { |education| education.destroy }
      @candidate.reload.main_education.should be_nil
    end
  end
end
