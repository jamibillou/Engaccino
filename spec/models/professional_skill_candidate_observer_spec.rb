require 'spec_helper'

describe ProfessionalSkillCandidateObserver do
  
  before(:each) do
    @candidate          = Factory(:candidate)
    @professional_skill = Factory(:professional_skill)
  end
  
  describe "update_profile_completion_create method" do

    before(:each) do
       @professional_skill_candidate1 = ProfessionalSkillCandidate.new(:level => 'beginner', :experience => 2)
       @professional_skill_candidate1.candidate = @candidate ; @professional_skill_candidate1.professional_skill = @professional_skill ; @professional_skill_candidate1.save!
    end

    it "should increase the profile completion by 10 when candidates with less than 2 professional skills add a new one (with a description)" do
      before_profile_completion_update = @candidate.profile_completion
      professional_skill_candidate2 = ProfessionalSkillCandidate.new(:level => 'expert',   :experience => 10, :description => 'Lorem ipsum bla bla bla bla bla bla bla')
      professional_skill_candidate2.candidate = @candidate ; professional_skill_candidate2.professional_skill = @professional_skill ; professional_skill_candidate2.save!
      @candidate.profile_completion.should == before_profile_completion_update + 10
    end
    
    it "should not increase the profile completion when candidates with 2 or more professional skills add a new one" do
      professional_skill_candidate2 = ProfessionalSkillCandidate.new(:level => 'expert',   :experience => 10, :description => 'Lorem ipsum bla bla bla bla bla bla bla')
      professional_skill_candidate2.candidate = @candidate ; professional_skill_candidate2.professional_skill = @professional_skill ; professional_skill_candidate2.save!
      before_profile_completion_update = @candidate.profile_completion
      professional_skill_candidate3 = ProfessionalSkillCandidate.new(:level => 'intermediate', :experience => 5)
      professional_skill_candidate3.candidate = @candidate ; professional_skill_candidate3.professional_skill = @professional_skill ; professional_skill_candidate3.save!
      @candidate.profile_completion.should == before_profile_completion_update
    end
  end

  describe "update_profile_completion_destroy method" do
  
    before(:each) do
      @professional_skill_candidate1 = ProfessionalSkillCandidate.new(:level => 'beginner', :experience => 1)
      @professional_skill_candidate2 = ProfessionalSkillCandidate.new(:level => 'advanced', :experience => 6, :description => 'Lorem ipsum bla bla bla bla bla bla bla')
      @professional_skill_candidate1.candidate = @candidate ; @professional_skill_candidate1.professional_skill = @professional_skill ; @professional_skill_candidate1.save!
      @professional_skill_candidate2.candidate = @candidate ; @professional_skill_candidate2.professional_skill = @professional_skill ; @professional_skill_candidate2.save!
    end

    it "should decrease the profile completion by 10 when candidates with 2 or less professional skills delete one" do
      before_profile_completion_update = @candidate.profile_completion
      @professional_skill_candidate1.destroy
      @candidate.profile_completion.should == before_profile_completion_update - 10
    end
    
    it "should not decrease the profile completion when candidates with more than 2 professional skills delete one" do
      professional_skill_candidate3 = ProfessionalSkillCandidate.new(:level => 'beginner', :experience => 2, :description => 'Lorem ipsum bla bla bla bla bla bla bla')
      professional_skill_candidate3.candidate = @candidate ; professional_skill_candidate3.professional_skill = @professional_skill ; professional_skill_candidate3.save!
      before_profile_completion_update = @candidate.profile_completion
      professional_skill_candidate3.destroy
      @candidate.profile_completion.should == before_profile_completion_update
    end
  end
end
