require 'spec_helper'

describe InterpersonalSkillCandidateObserver do
  
  before :each do
    @candidate           = Factory(:candidate)
    @interpersonal_skill = Factory(:interpersonal_skill)
  end
  
  describe 'update_profile_completion_create method' do

    before :each do
       @interpersonal_skill_candidate1 = Factory :interpersonal_skill_candidate, :candidate => @candidate
       @interpersonal_skill_candidate2 = Factory :interpersonal_skill_candidate, :candidate => @candidate
    end

    it 'should increase the profile completion by 5 when candidates with less than 3 interpersonal skills add a new one' do
      before_profile_completion_update = @candidate.profile_completion
      interpersonal_skill_candidate3 = Factory :interpersonal_skill_candidate, :candidate => @candidate
      @candidate.profile_completion.should == before_profile_completion_update + 5
    end
    
    it 'should not increase the profile completion when candidates with 3 or more interpersonal skills add a new one' do
      interpersonal_skill_candidate3 = Factory :interpersonal_skill_candidate, :candidate => @candidate
      before_profile_completion_update = @candidate.profile_completion
      interpersonal_skill_candidate4 = Factory :interpersonal_skill_candidate, :candidate => @candidate
      @candidate.profile_completion.should == before_profile_completion_update
    end
  end

  describe 'update_profile_completion_destroy method' do
  
    before :each do
      @interpersonal_skill_candidate1 = Factory :interpersonal_skill_candidate, :candidate => @candidate
      @interpersonal_skill_candidate2 = Factory :interpersonal_skill_candidate, :candidate => @candidate
      @interpersonal_skill_candidate3 = Factory :interpersonal_skill_candidate, :candidate => @candidate
    end

    it 'should decrease the profile completion by 10 when candidates with 3 or less interpersonal skills delete one' do
      before_profile_completion_update = @candidate.profile_completion
      @interpersonal_skill_candidate1.destroy
      @candidate.profile_completion.should == before_profile_completion_update - 5
    end
    
    it 'should not decrease the profile completion when candidates with more than 3 interpersonal skills delete one' do
      interpersonal_skill_candidate4 = Factory :interpersonal_skill_candidate, :candidate => @candidate
      before_profile_completion_update = @candidate.profile_completion
      interpersonal_skill_candidate4.destroy
      @candidate.profile_completion.should == before_profile_completion_update
    end
  end
end
