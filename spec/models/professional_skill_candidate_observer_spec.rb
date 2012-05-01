require 'spec_helper'

describe ProfessionalSkillCandidateObserver do
  
  before :each  do
    @candidate   = Factory :candidate 
    @pro_skill   = Factory :professional_skill
    @pro_skill_c = Factory :professional_skill_candidate, :candidate => @candidate
  end
  
  describe 'update_profile_completion_create method' do

    context 'a candidate with less than 2 professional skills adds a new one' do
      it 'should increase his profile completion by 10' do
        before = @candidate.profile_completion
        Factory :professional_skill_candidate, :candidate => @candidate
        @candidate.profile_completion.should == before + 10
      end
    end
    
    context 'a candidatewith 2 or more professional skills adds a new one' do
      it 'should not increase his profile completion' do
        Factory :professional_skill_candidate, :candidate => @candidate
        before = @candidate.profile_completion
        Factory :professional_skill_candidate, :candidate => @candidate
        @candidate.profile_completion.should == before
      end
    end
  end

  describe 'update_profile_completion_destroy method' do
  
    before :each do
      Factory :professional_skill_candidate, :candidate => @candidate
    end
    
    context 'a candidatewith 2 or less professional skills deletes one' do
      it 'should decrease his profile completion by 10' do
        before = @candidate.profile_completion
        @pro_skill_c.destroy
        @candidate.profile_completion.should == before - 10
      end
    end
    
    context 'a candidatewith more than 2 professional skills deletes one' do
      it 'should not decrease his profile completion' do
        Factory :professional_skill_candidate, :candidate => @candidate
        before = @candidate.profile_completion
        @pro_skill_c.destroy
        @candidate.profile_completion.should == before
      end
    end
  end
end
