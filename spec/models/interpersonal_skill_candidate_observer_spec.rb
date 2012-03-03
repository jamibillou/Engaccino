require 'spec_helper'

describe InterpersonalSkillCandidateObserver do
  
  before(:each) do
    @candidate           = Factory(:candidate)
    @interpersonal_skill = Factory(:interpersonal_skill)
  end
  
  describe "update_profile_completion_create method" do

    before(:each) do
       @interpersonal_skill_candidate1 = InterpersonalSkillCandidate.new(:level => 'beginner')
       @interpersonal_skill_candidate2 = InterpersonalSkillCandidate.new(:level => 'expert', :description => 'Lorem ipsum bla bla bla bla bla bla bla')
       @interpersonal_skill_candidate1.candidate = @candidate ; @interpersonal_skill_candidate1.interpersonal_skill = @interpersonal_skill ; @interpersonal_skill_candidate1.save!
       @interpersonal_skill_candidate2.candidate = @candidate ; @interpersonal_skill_candidate2.interpersonal_skill = @interpersonal_skill ; @interpersonal_skill_candidate2.save!
    end

    it "should increase the profile completion by 5 when candidates with less than 3 interpersonal skills add a new one" do
      before_profile_completion_update = @candidate.profile_completion
      interpersonal_skill_candidate3 = InterpersonalSkillCandidate.new(:level => 'beginner')
      interpersonal_skill_candidate3.candidate = @candidate ; interpersonal_skill_candidate3.interpersonal_skill = @interpersonal_skill ; interpersonal_skill_candidate3.save!
      @candidate.profile_completion.should == before_profile_completion_update + 5
    end
    
    it "should not increase the profile completion when candidates with 3 or more interpersonal skills add a new one" do
      interpersonal_skill_candidate3 = InterpersonalSkillCandidate.new(:level => 'expert', :description => 'Lorem ipsum bla bla bla bla bla bla bla')
      interpersonal_skill_candidate3.candidate = @candidate ; interpersonal_skill_candidate3.interpersonal_skill = @interpersonal_skill ; interpersonal_skill_candidate3.save!
      before_profile_completion_update = @candidate.profile_completion
      interpersonal_skill_candidate4 = InterpersonalSkillCandidate.new(:level => 'intermediate')
      interpersonal_skill_candidate4.candidate = @candidate ; interpersonal_skill_candidate4.interpersonal_skill = @interpersonal_skill ; interpersonal_skill_candidate4.save!
      @candidate.profile_completion.should == before_profile_completion_update
    end
  end

  describe "update_profile_completion_destroy method" do
  
    before(:each) do
      @interpersonal_skill_candidate1 = InterpersonalSkillCandidate.new(:level => 'beginner')
      @interpersonal_skill_candidate2 = InterpersonalSkillCandidate.new(:level => 'expert', :description => 'Lorem ipsum bla bla bla bla bla bla bla')
      @interpersonal_skill_candidate3 = InterpersonalSkillCandidate.new(:level => 'beginner')
      @interpersonal_skill_candidate1.candidate = @candidate ; @interpersonal_skill_candidate1.interpersonal_skill = @interpersonal_skill ; @interpersonal_skill_candidate1.save!
      @interpersonal_skill_candidate2.candidate = @candidate ; @interpersonal_skill_candidate2.interpersonal_skill = @interpersonal_skill ; @interpersonal_skill_candidate2.save!
      @interpersonal_skill_candidate3.candidate = @candidate ; @interpersonal_skill_candidate3.interpersonal_skill = @interpersonal_skill ; @interpersonal_skill_candidate3.save!
    end

    it "should decrease the profile completion by 10 when candidates with 3 or less interpersonal skills delete one" do
      before_profile_completion_update = @candidate.profile_completion
      @interpersonal_skill_candidate1.destroy
      @candidate.profile_completion.should == before_profile_completion_update - 5
    end
    
    it "should not decrease the profile completion when candidates with more than 3 interpersonal skills delete one" do
      interpersonal_skill_candidate4 = InterpersonalSkillCandidate.new(:level => 'beginner', :description => 'Lorem ipsum bla bla bla bla bla bla bla')
      interpersonal_skill_candidate4.candidate = @candidate ; interpersonal_skill_candidate4.interpersonal_skill = @interpersonal_skill ; interpersonal_skill_candidate4.save!
      before_profile_completion_update = @candidate.profile_completion
      interpersonal_skill_candidate4.destroy
      @candidate.profile_completion.should == before_profile_completion_update
    end
  end
end
