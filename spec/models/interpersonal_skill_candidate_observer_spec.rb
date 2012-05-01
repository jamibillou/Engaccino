require 'spec_helper'

describe InterpersonalSkillCandidateObserver do
  
  before :each do
    @candidate = Factory :candidate
    Factory :interpersonal_skill_candidate, :candidate => @candidate
    Factory :interpersonal_skill_candidate, :candidate => @candidate
  end
  
  describe 'update_profile_completion_create method' do
    
    context 'a candidate with less than 3 interpersonal skills adds a new one' do
      it 'should increase his profile completion by 5' do
        before = @candidate.profile_completion
        Factory :interpersonal_skill_candidate, :candidate => @candidate
        @candidate.profile_completion.should == before + 5
      end
    end
    
    context 'a candidate with 3 or more interpersonal skills adds a new one' do
      it 'should not increase his profile completion' do
        Factory :interpersonal_skill_candidate, :candidate => @candidate
        before = @candidate.profile_completion
        Factory :interpersonal_skill_candidate, :candidate => @candidate
        @candidate.profile_completion.should == before
      end
    end
  end

  describe 'update_profile_completion_destroy method' do
  
    before :each do
      @perso_skill_c_3 = Factory :interpersonal_skill_candidate, :candidate => @candidate
    end
    
    context 'a candidate with 3 or less interpersonal skills deletes one' do
      it 'should decrease his profile completion by 5' do
        before = @candidate.profile_completion
        @perso_skill_c_3.destroy
        @candidate.profile_completion.should == before - 5
      end
    end
    
    context 'a candidate with more than 3 interpersonal skills deletes one' do
      it 'should not decrease his profile completion' do
        Factory :interpersonal_skill_candidate, :candidate => @candidate
        before = @candidate.profile_completion
        @perso_skill_c_3.destroy
        @candidate.profile_completion.should == before
      end
    end
  end
end