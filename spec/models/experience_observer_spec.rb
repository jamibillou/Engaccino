require 'spec_helper'

describe ExperienceObserver do
  
  before :each do
    @candidate = Factory :candidate
    @company   = Factory :company
  end

  describe 'set_main method' do
      
    before :each do
      @experience1 = Factory :experience, :start_month => 1, :start_year => 2000, :end_month => 1, :end_year => 2001, :role => 'Sample postion', :candidate => @candidate
      @experience2 = Factory :experience, :start_month => 2, :start_year => 2001, :end_month => 2, :end_year => 2002, :role => 'Sample postion', :candidate => @candidate
      @experience3 = Factory :experience, :start_month => 3, :start_year => 2002, :end_month => 3, :end_year => 2003, :role => 'Sample postion', :candidate => @candidate
    end

    context 'new experience is added and it is the latest' do
      it 'should set it as main_experience' do
        experience4 = Factory :experience, :start_month => 4, :start_year => 2003, :end_month => 4, :end_year => 2004, :role => 'Sample postion', :candidate => @candidate
        @candidate.main_experience.should == experience4.id
      end
    end

    context 'an experience is updated to being the latest' do
      it 'should set it as main_experience' do
        @experience1.update_attributes(:start_month => 5, :start_year => 2004, :end_month => 5, :end_year => 2005)
        @candidate.main_experience.should == @experience1.id
      end
    end

    context 'the main_experience was updated and it is not the latest anymore' do
      it 'should set the latest experience as main_experience' do
        Experience.find_by_id(@candidate.main_experience).update_attributes(:start_month => 12, :start_year => 1998, :end_month => 12, :end_year => 1999)
        @candidate.reload.main_experience.should == @candidate.last_experience.id
      end
    end

    context 'the main_experience was deleted' do
      it 'should set the latest experience as main_experience' do
        Experience.find(@candidate.main_experience).destroy
        @candidate.reload.main_experience.should == @candidate.last_experience.id
      end
    end

    context 'all experiences were deleted' do
      it 'should the main_experience to nil' do
        @candidate.experiences.each { |experience| experience.destroy }
        @candidate.reload.main_experience.should be_nil
      end
    end
  end
    
  describe 'set_current_date method' do
      
    context 'a new current experience is added' do
      it 'should set the current date as its end date' do
         current_experience = Factory :experience, :start_month => 4, :start_year => 2003, :end_month => 4, :end_year => 2004, :role => 'Sample postion', :current => true, :candidate => @candidate 
         current_experience.end_month.should == Time.now.month
         current_experience.end_year.should  == Time.now.year
      end
    end
      
    context 'an experience is updated to current experience' do
      it 'should set the current date as its end date' do
         past_experience = Factory :experience, :start_month => 4, :start_year => 2003, :end_month => 4, :end_year => 2004, :role => 'Sample postion', :candidate => @candidate
         past_experience.toggle!(:current)
         past_experience.end_month.should == Time.now.month
         past_experience.end_year.should  == Time.now.year
      end
    end
  end
    
  describe 'update_profile_completion_create method' do

    before :each do
       @experience1 = Factory :experience, :start_month => 1, :start_year => 2000, :end_month => 1, :end_year => 2001, :role => 'Sample postion', :candidate => @candidate
       @experience2 = Factory :experience, :start_month => 1, :start_year => 2001, :end_month => 1, :end_year => 2002, :role => 'Sample postion', :description => 'Lorem ipsum bla bla bla bla bla bla bla', :candidate => @candidate
    end
      
    context 'a candidate with less than 3 experiences adds a new one' do
      it 'should increase his profile completion by 10' do
        before = @candidate.profile_completion
        experience3 = Factory :experience, :start_month => 4, :start_year => 2003, :end_month => 4, :end_year => 2004, :role => 'Sample postion', :description => 'Lorem ipsum bla bla bla bla bla bla bla', :candidate => @candidate
        @candidate.profile_completion.should == before + 10
      end
    end
      
    context 'a candidate with 3 or more experiences adds a new one' do
      it 'should not increase his profile completion' do
        experience3 = Factory :experience, :start_month => 4, :start_year => 2003, :end_month => 4, :end_year => 2004, :role => 'Sample postion', :candidate => @candidate
        before = @candidate.profile_completion
        experience4 = Factory :experience, :start_month => 4, :start_year => 2003, :end_month => 4, :end_year => 2004, :role => 'Sample postion', :candidate => @candidate
        @candidate.profile_completion.should == before
      end
    end
  end

  describe 'update_profile_completion_destroy method' do
    
    before :each do
      @experience1 = Factory :experience, :start_month => 1, :start_year => 2000, :end_month => 1, :end_year => 2001, :role => 'Sample postion', :candidate => @candidate
      @experience2 = Factory :experience, :start_month => 2, :start_year => 2001, :end_month => 2, :end_year => 2002, :role => 'Sample postion', :description => 'Lorem ipsum bla bla bla bla bla bla bla', :candidate => @candidate
      @experience3 = Factory :experience, :start_month => 3, :start_year => 2002, :end_month => 3, :end_year => 2003, :role => 'Sample postion', :candidate => @candidate
    end

    context 'a candidate with 3 or less experiences deletes one' do
      it 'should decrease his profile completion by 10' do
        before = @candidate.profile_completion
        @experience1.destroy
        @candidate.profile_completion.should == before - 10
      end
    end
      
    context 'a candidate with more than 3 experiences deletes one' do
      it 'should not decrease his profile completion' do
        experience4 = Factory :experience, :start_month => 4, :start_year => 2003, :end_month => 4, :end_year => 2004, :role => 'Sample postion', :candidate => @candidate
        before = @candidate.profile_completion
        experience4.destroy
        @candidate.profile_completion.should == before
      end
    end
  end
end