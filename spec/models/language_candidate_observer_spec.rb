require 'spec_helper'

describe LanguageCandidateObserver do
  
  before :each do
    @candidate = Factory :candidate
  end
  
  describe 'update_profile_completion_create method' do
    
    context 'a candidate with no language adds one' do
      it 'should increase his profile completion by 5' do
        before = @candidate.profile_completion
        language_candidate = Factory :language_candidate, :candidate => @candidate
        @candidate.profile_completion.should == before + 5
      end
    end
    
    context 'a candidate with 1 or more languages adds a new one' do
      it 'should not increase his profile completion' do
        language_candidate = Factory :language_candidate, :candidate => @candidate
        before = @candidate.profile_completion
        language_candidate2 = Factory :language_candidate, :candidate => @candidate
        @candidate.profile_completion.should == before
      end
    end
  end
  
  describe 'update_profile_completion_destroy method' do
    
    before :each do
      @language_candidate = Factory :language_candidate, :candidate => @candidate
    end
    
    context 'a candidats with 1 language deletes it' do
      it 'should decrease his profile completion by 5' do
        before = @candidate.profile_completion
        @language_candidate.destroy
        @candidate.profile_completion.should == before - 5
      end
    end
    
    context 'a candidate with more than 1 language deletes one' do
      it 'should not decrease his profile completion' do
        Factory :language_candidate, :candidate => @candidate
        before = @candidate.profile_completion
        @language_candidate.destroy
        @candidate.profile_completion.should == before
      end
    end
  end
end