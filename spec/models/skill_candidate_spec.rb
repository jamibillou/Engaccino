require 'spec_helper'

describe SkillCandidate do
  
  before(:each) do
    @attr                  = { :description => 'It is basically a fantastic skill which makes me very proud' }
    @candidate             = Factory(:candidate)
    @skill                 = Factory(:skill)
    @professional_skill    = Factory(:professional_skill)
    @interpersonal_skill   = Factory(:interpersonal_skill)
    @skill_candidate       = Factory(:skill_candidate, :candidate => @candidate, :skill => @skill)
  end
  
  it "should create an instance given valid attributes" do
    skill_candidate           = SkillCandidate.new(@attr)
    skill_candidate.candidate = @candidate
    skill_candidate.skill     = @skill
    skill_candidate.should be_valid
  end
  
  describe "candidate associations" do
  
    it "should have a candidate attribute" do
      @skill_candidate.should respond_to(:candidate)
    end
    
    it "should have the right associated candidate" do
      @skill_candidate.candidate_id.should == @candidate.id
      @skill_candidate.candidate.should    == @candidate
    end
  end
  
  describe "skill associations" do
  
    it "should have a skill attribute" do
      @skill_candidate.should respond_to(:skill)
    end
    
    it "should have the right associated skill" do
      @skill_candidate.skill_id.should == @skill.id
      @skill_candidate.skill.should    == @skill
    end
  end
  
  describe "validations" do
  
    it "should require a description" do
      no_description_skill_candidate           = SkillCandidate.new @attr.merge(:description => '')
      no_description_skill_candidate.candidate = @candidate
      no_description_skill_candidate.skill     = @skill
      no_description_skill_candidate.should_not be_valid
    end
    
    it "should reject too short descriptions" do
      short_description_skill_candidate           = SkillCandidate.new @attr.merge(:description => 'a'*19)
      short_description_skill_candidate.candidate = @candidate
      short_description_skill_candidate.skill     = @skill
      short_description_skill_candidate.should_not be_valid
    end
    
    it "should reject too long descriptions" do
      long_description_skill_candidate           = SkillCandidate.new @attr.merge(:description => 'a'*161)
      long_description_skill_candidate.candidate = @candidate
      long_description_skill_candidate.skill     = @skill
      long_description_skill_candidate.should_not be_valid
    end
    
    describe "when associated to a professional skill" do
      
      it "should require a level" do
        no_level_skill_candidate           = SkillCandidate.new @attr.merge(:experience => 3)
        no_level_skill_candidate.candidate = @candidate
        no_level_skill_candidate.skill     = @professional_skill
        no_level_skill_candidate.should_not be_valid
      end
      
      it "should reject a invalid levels" do
        invalid_levels = [ 'pouet', 'invalid_level', '45346', '...' ]
        invalid_levels.each do |invalid_level|
          invalid_level_skill_candidate           = SkillCandidate.new(@attr.merge(:level => invalid_level, :experience => 3))
          invalid_level_skill_candidate.candidate = @candidate
          invalid_level_skill_candidate.skill     = @professional_skill
          invalid_level_skill_candidate.should_not be_valid
        end
      end
      
      it "should accept a valid levels" do
        valid_levels = [ 'beginner', 'intermediate', 'advanced', 'expert' ]
        valid_levels.each do |valid_level|
          valid_level_skill_candidate           = SkillCandidate.new(@attr.merge(:level => valid_level, :experience => 3))
          valid_level_skill_candidate.candidate = @candidate
          valid_level_skill_candidate           = @professional_skill
          valid_level_skill_candidate.should be_valid
        end
      end
      
      it "should require an experience" do
        no_experience_skill_candidate           = SkillCandidate.new @attr.merge(:level => 'beginner')
        no_experience_skill_candidate.candidate = @candidate
        no_experience_skill_candidate.skill     = @professional_skill
        no_experience_skill_candidate.should_not be_valid
      end
      
      it "should reject a invalid experiences" do
        invalid_experiences = [ 'pouet', 'invalid_experience', '45346', '...' ]
        invalid_experiences.each do |invalid_experience|
          invalid_experience_skill_candidate           = SkillCandidate.new(@attr.merge(:experience => invalid_experience, :level => 'beginner'))
          invalid_experience_skill_candidate.candidate = @candidate
          invalid_experience_skill_candidate.skill     = @professional_skill
          invalid_experience_skill_candidate.should_not be_valid
        end
      end
      
      it "should accept a valid experiences" do
        valid_experiences = [ 1, 5, 25, 38, 46, 59]
        valid_experiences.each do |valid_experience|
          valid_experience_skill_candidate           = SkillCandidate.new(@attr.merge(:experience => valid_experience, :level => 'beginner'))
          valid_experience_skill_candidate.candidate = @candidate
          valid_experience_skill_candidate           = @professional_skill
          valid_experience_skill_candidate.should be_valid
        end
      end
    end
    
    describe "when associated to an interpersonal skill" do
    
      it "should allow blank levels and experiences" do
        blank_level_experience_skill_candidate           = SkillCandidate.new @attr
        blank_level_experience_skill_candidate.candidate = @candidate
        blank_level_experience_skill_candidate.skill     = @interpersonal_skill
        blank_level_experience_skill_candidate.should be_valid
      end
      
      it "should reject non blank experiences" do
        non_blank_experience_skill_candidate           = SkillCandidate.new @attr.merge(:experience => 3)
        non_blank_experience_skill_candidate.candidate = @candidate
        non_blank_experience_skill_candidate.skill     = @interpersonal_skill
        non_blank_experience_skill_candidate.should_not be_valid
      end
      
      it "should reject non blank levels" do
        non_blank_level_skill_candidate           = SkillCandidate.new @attr.merge(:level => 'beginner')
        non_blank_level_skill_candidate.candidate = @candidate
        non_blank_level_skill_candidate.skill     = @interpersonal_skill
        non_blank_level_skill_candidate.should_not be_valid
      end
    end
  end
end
# == Schema Information
#
# Table name: skill_candidates
#
#  id           :integer(4)      not null, primary key
#  level        :string(255)
#  experience   :integer(4)
#  description  :string(255)
#  candidate_id :integer(4)
#  skill_id     :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

