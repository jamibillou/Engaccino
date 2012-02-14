require 'spec_helper'

describe Skill do

  before(:each) do
    @attr            = { :label => "Sample skill" }
    @candidate       = Factory(:candidate)
    @skill           = Factory(:skill)
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
    
    it "should reject too long labels" do
      skill = Skill.new(@attr.merge(:label => 'a'*101))
      skill.should_not be_valid
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

