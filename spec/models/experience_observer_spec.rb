require 'spec_helper'

describe ExperienceObserver do
  
    before(:each) do
      @candidate  = Factory(:candidate)
      @company    = Factory(:company)
      @experience1 = Experience.new(:start_month => 1, :start_year => 2000, :end_month => 1, :end_year => 2001, :role => 'Sample postion')
      @experience2 = Experience.new(:start_month => 2, :start_year => 2001, :end_month => 2, :end_year => 2002, :role => 'Sample postion')
      @experience3 = Experience.new(:start_month => 3, :start_year => 2002, :end_month => 3, :end_year => 2003, :role => 'Sample postion')
      @experience1.candidate = @candidate ; @experience1.company = @company
      @experience2.candidate = @candidate ; @experience2.company = @company
      @experience3.candidate = @candidate ; @experience3.company = @company
      [ @experience1, @experience2, @experience3 ].each { |experience| experience.save! }
    end

    describe "set_main method" do

      it "should set a new experience as main if it's the candidate's latest one" do
        experience4 = Experience.new(:start_month => 4, :start_year => 2003, :end_month => 4, :end_year => 2004, :role => 'Sample postion')
        experience4.candidate = @candidate ; experience4.company = @company
        experience4.save!
        @candidate.main_experience.should == experience4.id
      end

      it "should set an experience as main if it was updated to being the candidate's latest one" do
        @experience1.update_attributes(:start_month => 5, :start_year => 2004, :end_month => 5, :end_year => 2005)
        @experience1.save!
        @candidate.main_experience.should == @experience1.id
      end

      it "should set a candidate's latest experience as main if his former main experience was updated with dates that make it not being the latest one anymore" do
        Experience.find_by_id(@candidate.main_experience).update_attributes(:start_month => 12, :start_year => 1998, :end_month => 12, :end_year => 1999)
        @candidate.reload.main_experience.should == @candidate.last_experience.id
      end

      it "should set a candidate's latest experience as main if his former main experience was deleted" do
        Experience.find(@candidate.main_experience).destroy
        @candidate.reload.main_experience.should == @candidate.last_experience.id
      end

      it "should set a candidate's main experience to nil after he deleted all of them" do
        @candidate.experiences.each { |experience| experience.destroy }
        @candidate.reload.main_experience.should be_nil
      end
    end
    
    describe "set_current_date method" do
      
      it "should set the current date as the end date of a new current experience" do
         current_experience = Experience.new(:start_month => 4, :start_year => 2003, :end_month => 4, :end_year => 2004, :role => 'Sample postion', :current => true)
         current_experience.candidate = @candidate ; current_experience.company = @company
         current_experience.save!
         current_experience.end_month.should == Time.now.month
         current_experience.end_year.should  == Time.now.year
      end
      
      it "should set the current date as the end date of an experience updated to current" do
         past_experience = Experience.new(:start_month => 4, :start_year => 2003, :end_month => 4, :end_year => 2004, :role => 'Sample postion')
         past_experience.candidate = @candidate ; past_experience.company = @company
         past_experience.save!
         past_experience.toggle!(:current)
         past_experience.end_month.should == Time.now.month
         past_experience.end_year.should  == Time.now.year
      end
    end
  end
