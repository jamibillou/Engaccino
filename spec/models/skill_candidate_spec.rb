require 'spec_helper'

describe SkillCandidate do
  
  before(:each) do
    @attr                  = { :description => 'It is basically a fantastic skill which makes me very proud' }
    @candidate             = Factory(:candidate)
    @skill                 = Factory(:skill)
    @skill_pro             = Factory(:skill_pro)
    @skill_perso           = Factory(:skill_perso)
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
      skill_candidate = SkillCandidate.new @attr.merge(:description => '')
      skill_candidate.candidate = @candidate
      skill_candidate.skill     = @skill
      skill_candidate.should_not be_valid
    end
    
    it "should reject too short descriptions" do
      skill_candidate = SkillCandidate.new @attr.merge(:description => 'a'*19)
      skill_candidate.candidate = @candidate
      skill_candidate.skill     = @skill
      skill_candidate.should_not be_valid
    end
    
    it "should reject too long descriptions" do
      skill_candidate = SkillCandidate.new @attr.merge(:description => 'a'*161)
      skill_candidate.candidate = @candidate
      skill_candidate.skill     = @skill
      skill_candidate.should_not be_valid
    end
    
    describe "when associated to a professional skill" do
      
      it "should require a level" do
        skill_candidate = SkillCandidate.new @attr.merge(:experience => 3)
        skill_candidate.candidate = @candidate
        skill_candidate.skill     = @skill_pro
        skill_candidate.should_not be_valid
      end
      
      it "should require an experience" do
        skill_candidate = SkillCandidate.new @attr.merge(:level => 'beginner')
        skill_candidate.candidate = @candidate
        skill_candidate.skill     = @skill_pro
        skill_candidate.should_not be_valid
      end
    end
    
    describe "when associated to an interpersonal skill" do
    
      it "should allow blank levels and experiences" do
        skill_candidate = SkillCandidate.new @attr
        skill_candidate.candidate = @candidate
        skill_candidate.skill     = @skill_perso
        skill_candidate.should be_valid
      end
      
      it "should reject non blank experiences" do
        skill_candidate = SkillCandidate.new @attr.merge(:experience => 3)
        skill_candidate.candidate = @candidate
        skill_candidate.skill     = @skill_perso
        skill_candidate.should_not be_valid
      end
      
      it "should reject non blank levels" do
        skill_candidate = SkillCandidate.new @attr.merge(:level => 'beginner')
        skill_candidate.candidate = @candidate
        skill_candidate.skill     = @skill_perso
        skill_candidate.should_not be_valid
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

