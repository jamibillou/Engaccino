require 'spec_helper'

describe InterpersonalSkillCandidate do
  before(:each) do
    @attr                  = { :description => 'It is basically a fantastic skill which makes me very proud' }
    @candidate             = Factory(:candidate)
    @interpersonal_skill   = Factory(:interpersonal_skill)
    @interpersonal_skill_candidate = Factory(:interpersonal_skill_candidate, :candidate => @candidate, 
                                             :interpersonal_skill => @interpersonal_skill)
  end
  
  it "should create an instance given valid attributes" do
    interpersonal_skill_candidate                         = InterpersonalSkillCandidate.new(@attr)
    interpersonal_skill_candidate.candidate               = @candidate
    interpersonal_skill_candidate.interpersonal_skill     = @interpersonal_skill
    interpersonal_skill_candidate.should be_valid
  end
  
  describe "candidate associations" do
  
    it "should have a candidate attribute" do
      @interpersonal_skill_candidate.should respond_to(:candidate)
    end
    
    it "should have the right associated candidate" do
      @interpersonal_skill_candidate.candidate_id.should == @candidate.id
      @interpersonal_skill_candidate.candidate.should    == @candidate
    end
    
    it "should not destroy the associated candidate" do
      @interpersonal_skill_candidate.destroy
      Candidate.find(@candidate).should_not be_nil
    end
  end
  
  describe "interpersonal_skill associations" do
  
    it "should have a interpersonal_skill attribute" do
      @interpersonal_skill_candidate.should respond_to(:interpersonal_skill)
    end
    
    it "should have the right associated interpersonal_skill" do
      @interpersonal_skill_candidate.interpersonal_skill_id.should == @interpersonal_skill.id
      @interpersonal_skill_candidate.interpersonal_skill.should    == @interpersonal_skill
    end
    
    it "should not destroy the associated interpersonal_skill" do
      @interpersonal_skill_candidate.destroy
      InterpersonalSkill.find(@interpersonal_skill).should_not be_nil
    end
  end
  
  describe "validations" do
  
    it "should accept empty descriptions" do
      no_description_interpersonal_skill_candidate                      = InterpersonalSkillCandidate.new @attr.merge(:description => '')
      no_description_interpersonal_skill_candidate.candidate            = @candidate
      no_description_interpersonal_skill_candidate.interpersonal_skill  = @interpersonal_skill
      no_description_interpersonal_skill_candidate.should be_valid
    end
    
    it "should reject too short descriptions" do
      short_description_interpersonal_skill_candidate                     = InterpersonalSkillCandidate.new @attr.merge(:description => 'a'*19)
      short_description_interpersonal_skill_candidate.candidate           = @candidate
      short_description_interpersonal_skill_candidate.interpersonal_skill = @interpersonal_skill
      short_description_interpersonal_skill_candidate.should_not be_valid
    end
    
    it "should reject too long descriptions" do
      long_description_interpersonal_skill_candidate                     = InterpersonalSkillCandidate.new @attr.merge(:description => 'a'*161)
      long_description_interpersonal_skill_candidate.candidate           = @candidate
      long_description_interpersonal_skill_candidate.interpersonal_skill = @interpersonal_skill
      long_description_interpersonal_skill_candidate.should_not be_valid
    end
  end
end

# == Schema Information
#
# Table name: interpersonal_skill_candidates
#
#  id                     :integer(4)      not null, primary key
#  description            :string(255)
#  candidate_id           :integer(4)
#  interpersonal_skill_id :integer(4)
#  created_at             :datetime
#  updated_at             :datetime
#

