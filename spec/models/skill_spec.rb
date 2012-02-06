require 'spec_helper'

describe Skill do

  before(:each) do
    @attr            = { :label => "Sample skill" }
    @candidate       = Factory(:candidate)
    @skill           = Factory(:skill)
    @skill_candidate = Factory(:skill_candidate, :candidate => @candidate, :skill => @skill)
  end
  
  it "should create an instance given valid attributes" do
    skill = Skill.create(@attr)
    skill.should be_valid
  end
  
  describe "validations" do
  
    it "should require a label" do
      skill = Skill.new(@attr.merge(:label => ''))
      skill.should_not be_valid
    end
    
    it "should reject too short labels" do
      skill = Skill.new(@attr.merge(:label => 'a'))
      skill.should_not be_valid
    end
    
    it "should reject too long labels" do
      skill = Skill.new(@attr.merge(:label => 'a'*101))
      skill.should_not be_valid
    end
    
    it "should reject invalid labels" do
      invalid_labels = [ "erg*&%$#!", 'grgdgdfg_dffdg', '98753igsdviug wyugf 35' ]
      invalid_labels.each do |invalid_label|
        skill = Skill.new(@attr.merge(:label => invalid_label))
        skill.should_not be_valid
      end
    end
    
    it "should accept valid labels" do
      valid_labels = [ 'Graphic Design', 'Software Development', 'Baby sitting', 'Customer Service', 'Sales' ]
      valid_labels.each do |valid_label|
        skill = Skill.new(@attr.merge(:label => valid_label))
        skill.should be_valid
      end
    end
  end
  
  describe "skill_candidates associations" do
    
    it "should have a skill_candidates attribute" do
      @skill.should respond_to(:skill_candidates)
    end
    
    it "should destroy associated skill_candidates" do
      @skill.destroy
      SkillCandidate.find_by_id(@skill_candidate.id).should be_nil
    end
  end
end

# == Schema Information
#
# Table name: skills
#
#  id         :integer(4)      not null, primary key
#  label      :string(255)
#  type       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

