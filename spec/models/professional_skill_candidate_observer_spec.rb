require 'spec_helper'

describe ProfessionalSkillCandidateObserver do
  
  before :each  do
    @candidate          = Factory :candidate 
    @professional_skill = Factory :professional_skill
  end
  
  describe 'update_profile_completion_create method' do

    before :each do
       @professional_skill_candidate1 = Factory :professional_skill_candidate, :candidate => @candidate
    end

    it 'should increase the profile completion by 10 when candidates with less than 2 professional skills add a new one (with a description)' do
      before_profile_completion_update = @candidate.profile_completion
      professional_skill_candidate2 = Factory :professional_skill_candidate, :candidate => @candidate
      @candidate.profile_completion.should == before_profile_completion_update + 10
    end
    
    it 'should not increase the profile completion when candidates with 2 or more professional skills add a new one' do
      professional_skill_candidate2 = Factory :professional_skill_candidate, :candidate => @candidate
      before_profile_completion_update = @candidate.profile_completion
      professional_skill_candidate3 = Factory :professional_skill_candidate, :candidate => @candidate
      @candidate.profile_completion.should == before_profile_completion_update
    end
  end

  describe 'update_profile_completion_destroy method' do
  
    before :each do
      @professional_skill_candidate1 = Factory :professional_skill_candidate, :candidate => @candidate
      @professional_skill_candidate2 = Factory :professional_skill_candidate, :candidate => @candidate
    end

    it 'should decrease the profile completion by 10 when candidates with 2 or less professional skills delete one' do
      before_profile_completion_update = @candidate.profile_completion
      @professional_skill_candidate1.destroy
      @candidate.profile_completion.should == before_profile_completion_update - 10
    end
    
    it 'should not decrease the profile completion when candidates with more than 2 professional skills delete one' do
      professional_skill_candidate3 = Factory :professional_skill_candidate, :candidate => @candidate
      before_profile_completion_update = @candidate.profile_completion
      professional_skill_candidate3.destroy
      @candidate.profile_completion.should == before_profile_completion_update
    end
  end
end
