require 'spec_helper'

describe Certificate do
  
  before(:each) do
    @attr            = { :label => "Sample certificate" }
    @candidate       = Factory(:candidate)
  end
  
  it "should create an instance given valid attributes" do
    certificate = Certificate.create(@attr)
    certificate.should be_valid
  end
  
  describe "validations" do
  
    it "should require a label" do
      certificate = Certificate.new(@attr.merge(:label => ''))
      certificate.should_not be_valid
    end
    
    it "should reject too long labels" do
      certificate = Certificate.new(@attr.merge(:label => 'a'*101))
      certificate.should_not be_valid
    end
  end
end
# == Schema Information
#
# Table name: certifications
#
#  id         :integer(4)      not null, primary key
#  label      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

