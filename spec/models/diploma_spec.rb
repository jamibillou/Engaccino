require 'spec_helper'

describe Diploma do

  before(:each) do
    @attr = { :label => 'Marketing Management' }
    @diploma = Factory(:diploma)
    @diploma_type = Factory(:diploma_type, :diploma => @diploma)
  end

  it "should create an instance given valid attributes" do
    diploma = Diploma.create!(@attr)
    diploma.should be_valid
  end
  
  describe "diploma types associations" do
    
    it "should have an diplomatypes attribute" do
      @diploma.should respond_to(:diplomaTypes)
    end
    
    it "should not destroy associated associated diploma types" do
      @diploma.destroy
      DiplomaType.find(@diploma_type).should_not be_nil
    end
  end
  
  describe "attributes validations" do
    
    it "should require a label" do
      invalid_diploma = Diploma.new(@attr.merge(:label => ""))
      invalid_diploma.should_not be_valid
    end
    
    it "should reject too short labels" do
      short_diploma = Diploma.new(@attr.merge(:label => "xx"))
      short_diploma.should_not be_valid
    end
    
    it "should reject too long labels" do
      long_label = 'a' * 151
      long_diploma = Diploma.new(@attr.merge(:label => long_label))
      long_diploma.should_not be_valid
    end
  end

end
# == Schema Information
#
# Table name: diplomas
#
#  id         :integer(4)      not null, primary key
#  label      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

