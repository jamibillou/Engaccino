require 'spec_helper'

describe ProfessionalSkillCandidate do
  before(:each) do
    @attr                  = { :description => 'It is basically a fantastic skill which makes me very proud',
                               :experience => '3', :level => 'expert' }
    @candidate             = Factory(:candidate)
    @professional_skill    = Factory(:professional_skill)
    @professional_skill_candidate = Factory(:professional_skill_candidate, :candidate => @candidate, 
                                            :professional_skill => @professional_skill)
  end
  
  it "should create an instance given valid attributes" do
    professional_skill_candidate                    = ProfessionalSkillCandidate.new(@attr)
    professional_skill_candidate.candidate          = @candidate
    professional_skill_candidate.professional_skill = @professional_skill
    professional_skill_candidate.should be_valid
  end
  
  describe "candidate associations" do
  
    it "should have a candidate attribute" do
      @professional_skill_candidate.should respond_to(:candidate)
    end
    
    it "should have the right associated candidate" do
      @professional_skill_candidate.candidate_id.should == @candidate.id
      @professional_skill_candidate.candidate.should    == @candidate
    end
    
    it "should not destroy associated candidate" do
      @professional_skill_candidate.destroy
      Candidate.find_by_id(@candidate.id).should_not be_nil
    end
  end
  
  describe "professional_skill associations" do
  
    it "should have a professional_skill attribute" do
      @professional_skill_candidate.should respond_to(:professional_skill)
    end
    
    it "should have the right associated professional_skill" do
      @professional_skill_candidate.professional_skill_id.should == @professional_skill.id
      @professional_skill_candidate.professional_skill.should    == @professional_skill
    end
    
    it "should not destroy associated professional_skill" do
      @professional_skill_candidate.destroy
      ProfessionalSkill.find_by_id(@professional_skill.id).should_not be_nil
    end
  end
  
  describe "validations" do
  
    it "should accept empty descriptions" do
      no_description_professional_skill_candidate                      = ProfessionalSkillCandidate.new @attr.merge(:description => '')
      no_description_professional_skill_candidate.candidate            = @candidate
      no_description_professional_skill_candidate.professional_skill   = @professional_skill
      no_description_professional_skill_candidate.should be_valid
    end
    
    it "should reject too short descriptions" do
      short_description_professional_skill_candidate                      = ProfessionalSkillCandidate.new @attr.merge(:description => 'a'*19)
      short_description_professional_skill_candidate.candidate            = @candidate
      short_description_professional_skill_candidate.professional_skill   = @professional_skill
      short_description_professional_skill_candidate.should_not be_valid
    end
    
    it "should reject too long descriptions" do
      long_description_professional_skill_candidate                      = ProfessionalSkillCandidate.new @attr.merge(:description => 'a'*161)
      long_description_professional_skill_candidate.candidate            = @candidate
      long_description_professional_skill_candidate.professional_skill   = @professional_skill
      long_description_professional_skill_candidate.should_not be_valid
    end
    
    it "should require a level" do
      no_level_professional_skill_candidate                        = ProfessionalSkillCandidate.new @attr.merge(:level => '')
      no_level_professional_skill_candidate.candidate              = @candidate
      no_level_professional_skill_candidate.professional_skill     = @professional_skill
      no_level_professional_skill_candidate.should_not be_valid
    end
    
    it "should reject a invalid levels" do
      invalid_levels = [ 'pouet', 'invalid_level', '45346', '...' ]
      invalid_levels.each do |invalid_level|
        invalid_level_professional_skill_candidate                      = ProfessionalSkillCandidate.new(@attr.merge(:level => invalid_level, :experience => 3))
        invalid_level_professional_skill_candidate.candidate            = @candidate
        invalid_level_professional_skill_candidate.professional_skill   = @professional_skill
        invalid_level_professional_skill_candidate.should_not be_valid
      end
    end
    
    it "should accept a valid levels" do
      valid_levels = [ 'beginner', 'intermediate', 'advanced', 'expert' ]
      valid_levels.each do |valid_level|
        valid_level_professional_skill_candidate                     = ProfessionalSkillCandidate.new(@attr.merge(:level => valid_level, :experience => 3))
        valid_level_professional_skill_candidate.candidate           = @candidate
        valid_level_professional_skill_candidate.professional_skill  = @professional_skill
        valid_level_professional_skill_candidate.should be_valid
      end
    end
    
    it "should require an experience" do
      no_experience_professional_skill_candidate                      = ProfessionalSkillCandidate.new @attr.merge(:experience => '')
      no_experience_professional_skill_candidate.candidate            = @candidate
      no_experience_professional_skill_candidate.professional_skill   = @professional_skill
      no_experience_professional_skill_candidate.should_not be_valid
    end
    
    it "should reject a invalid experiences" do
      invalid_experiences = [ 'pouet', 'invalid_experience', '45346', '...' ]
      invalid_experiences.each do |invalid_experience|
        invalid_experience_professional_skill_candidate                      = ProfessionalSkillCandidate.new(@attr.merge(:experience => invalid_experience, :level => 'beginner'))
        invalid_experience_professional_skill_candidate.candidate            = @candidate
        invalid_experience_professional_skill_candidate.professional_skill   = @professional_skill
        invalid_experience_professional_skill_candidate.should_not be_valid
      end
    end
    
    it "should accept a valid experiences" do
      valid_experiences = [ 1, 5, 25, 38, 46, 59]
      valid_experiences.each do |valid_experience|
        valid_experience_professional_skill_candidate                     = ProfessionalSkillCandidate.new(@attr.merge(:experience => valid_experience, :level => 'beginner'))
        valid_experience_professional_skill_candidate.candidate           = @candidate
        valid_experience_professional_skill_candidate.professional_skill  = @professional_skill
        valid_experience_professional_skill_candidate.should be_valid
      end
    end
  end
end

# == Schema Information
#
# Table name: professional_skill_candidates
#
#  id                    :integer(4)      not null, primary key
#  level                 :string(255)
#  experience            :integer(4)
#  description           :string(255)
#  candidate_id          :integer(4)
#  professional_skill_id :integer(4)
#  created_at            :datetime
#  updated_at            :datetime
#

