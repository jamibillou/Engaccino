require 'spec_helper'

describe EducationObserver do
  
  before :each do
    @candidate  = Factory :candidate
    @school     = Factory :school
    @degree     = Factory :degree
  end
  
  describe 'set_main method' do
    
    before :each do
      @education1 = Factory :education, :start_month => 1, :start_year => 2000, :end_month => 1, :end_year => 2001, :candidate => @candidate
      @education2 = Factory :education, :start_month => 2, :start_year => 2001, :end_month => 2, :end_year => 2002, :candidate => @candidate
      @education3 = Factory :education, :start_month => 3, :start_year => 2002, :end_month => 3, :end_year => 2003, :candidate => @candidate
    end
        
    context 'new education is added and it is the latest' do
      it 'should set it as main_education' do
        education4 = Factory :education, :candidate => @candidate
        @candidate.main_education.should == education4.id
      end
    end
    
    context 'an education is updated to being the latest' do
      it 'should set it as main_education' do
        @education1.update_attributes :start_month => 5, :start_year => 2004, :end_month => 5, :end_year => 2005
        @candidate.main_education.should == @education1.id
      end
    end
    
    context 'the main_education was updated and it is not the latest anymore' do
      it 'should set the latest education as main_education' do
        Education.find_by_id(@candidate.main_education).update_attributes :start_month => 12, :start_year => 1998, :end_month => 12, :end_year => 1999
        @candidate.reload.main_education.should == @candidate.last_education.id
      end
    end
    
    context 'the main_education was deleted' do
      it 'should set the latest education as main_education' do
        Education.find(@candidate.main_education).destroy
        @candidate.reload.main_education.should == @candidate.last_education.id
      end
    end
  
    context 'all educations were deleted' do
      it 'should the main_education to nil' do
        @candidate.educations.each { |education| education.destroy }
        @candidate.reload.main_education.should be_nil
      end
    end
  end
  
  describe 'update_profile_completion_create method' do
    
    before :each do
      @education1 = Factory :education, :candidate => @candidate
    end
        
    context 'a candidate with less than 2 educations adds a new one' do
      it 'should increase his profile completion by 10' do
        before = @candidate.profile_completion
        Factory :education, :candidate => @candidate
        @candidate.profile_completion.should == before + 10
      end
    end
    
    context 'a candidate with 2 or more educations adds a new one' do
      it 'should not increase his profile completion' do
        education2 = Factory :education, :candidate => @candidate
        before = @candidate.profile_completion
        education3 = Factory :education, :candidate => @candidate
        @candidate.profile_completion.should == before
      end
    end
  end
  
  describe 'update_profile_completion_destroy method' do
    
    before :each do
      @education1 = Factory :education, :candidate => @candidate
      @education2 = Factory :education, :candidate => @candidate
    end
    
    context 'a candidate with 2 or less educations deletes one' do
      it 'should decrease his profile completion by 10' do
        before = @candidate.profile_completion
        @education1.destroy
        @candidate.profile_completion.should == before - 10
      end 
    end 
    
    context 'a candidate with more than 2 educations deletes one' do
      it 'should not decrease his profile completion' do
        education3 = Factory :education, :candidate => @candidate
        before = @candidate.profile_completion
        education3.destroy
        @candidate.profile_completion.should == before
      end 
    end 
  end
end