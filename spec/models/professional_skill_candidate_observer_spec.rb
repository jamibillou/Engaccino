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

    it "should increase the profile completion by 5 when candidates with less than 3 professional skills add a new one (without description)" do
      before_profile_completion_update = @candidate.profile_completion
      professional_skill_candidate2 = ProfessionalSkillCandidate.new(:level => 'beginner', :experience => 2)
      professional_skill_candidate2.candidate = @candidate ; professional_skill_candidate2.professional_skill = @professional_skill ; professional_skill_candidate2.save!
      @candidate.profile_completion.should == before_profile_completion_update + 5
    end

    it "should increase the profile completion by 10 when candidates with less than 3 professional skills add a new one (with a description)" do
      before_profile_completion_update = @candidate.profile_completion
      professional_skill_candidate2 = ProfessionalSkillCandidate.new(:level => 'expert',   :experience => 10, :description => 'Lorem ipsum bla bla bla bla bla bla bla')
      professional_skill_candidate2.candidate = @candidate ; professional_skill_candidate2.professional_skill = @professional_skill ; professional_skill_candidate2.save!
      @candidate.profile_completion.should == before_profile_completion_update + 10
    end
    
    it "should not increase the profile completion when candidates with 3 or more professional skills add a new one" do
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

    it "should decrease the profile completion by 5 when candidates with 3 or less professional skills delete one (without description)" do
      before_profile_completion_update = @candidate.profile_completion
      @professional_skill_candidate1.destroy
      @candidate.profile_completion.should == before_profile_completion_update - 5
    end

    it "should decrease the profile completion by 10 when candidates with 3 or less professional skills delete one (with a description)" do
      before_profile_completion_update = @candidate.profile_completion
      @professional_skill_candidate2.destroy
      @candidate.profile_completion.should == before_profile_completion_update - 10
    end
    
    it "should not decrease the profile completion when candidates with more than 3 professional skills delete one" do
      professional_skill_candidate3 = ProfessionalSkillCandidate.new(:level => 'beginner', :experience => 2, :description => 'Lorem ipsum bla bla bla bla bla bla bla')
      professional_skill_candidate3.candidate = @candidate ; professional_skill_candidate3.professional_skill = @professional_skill ; professional_skill_candidate3.save!
      before_profile_completion_update = @candidate.profile_completion
      professional_skill_candidate3.destroy
      @candidate.profile_completion.should == before_profile_completion_update
    end
  end
  
  describe "update_profile_completion_update method" do
    
    before(:each) do
       @professional_skill_candidate1 = ProfessionalSkillCandidate.new(:level => 'intermediate', :experience => 3)
       @professional_skill_candidate2 = ProfessionalSkillCandidate.new(:level => 'beginner', :experience => 1, :description => 'Lorem ipsum bla bla bla bla bla bla bla')
       @professional_skill_candidate1.candidate = @candidate ; @professional_skill_candidate1.professional_skill = @professional_skill ; @professional_skill_candidate1.save!
       @professional_skill_candidate2.candidate = @candidate ; @professional_skill_candidate2.professional_skill = @professional_skill ; @professional_skill_candidate2.save!
    end
    
    it "should increase the profile completion by 5 when a description is added to a professional skill which didn't have one" do
      before_profile_completion_update = @candidate.profile_completion
      @professional_skill_candidate1.update_attributes(:description => 'Lorem ipsum bla bla bla bla bla bla bla')
      @candidate.profile_completion.should == before_profile_completion_update + 5
    end
    
    it "should increase the profile completion by 5 when a description is added to a professional skill which first had one, and then not" do
      before_profile_completion_update = @candidate.profile_completion
      @professional_skill_candidate2.update_attributes(:description => '')
      @professional_skill_candidate2.update_attributes(:description => 'Lorem ipsum bla bla bla bla bla bla bla')
      @candidate.profile_completion.should == before_profile_completion_update
    end
    
    it "should decrease the profile completion by 5 when a description is deleted from a professional skill which had one" do
      before_profile_completion_update = @candidate.profile_completion
      @professional_skill_candidate2.update_attributes(:description => '')
      @candidate.profile_completion.should == before_profile_completion_update - 5
    end
    
    it "should not increase or decrease the profile completion when a description is edited but not deleted" do
      before_profile_completion_update = @candidate.profile_completion
      @professional_skill_candidate2.update_attributes(:description => 'Bla bla bla bla bla bla bla bla bla')
      @candidate.profile_completion.should == before_profile_completion_update
    end
  end
end
