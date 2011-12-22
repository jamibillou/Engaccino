require 'spec_helper'

describe DiplomaType do

  before(:each) do
    @attr = { :label => "IUT"}
    @diploma = Factory(:diploma) 
    @diploma_type = Factory(:diploma_type, :diploma => @diploma)
  end

  it "should create an instance given valid attributes" do
    diploma_type = DiplomaType.new(@attr)
    diploma_type.diploma = @diploma
    diploma_type.save!
    diploma_type.should be_valid
  end
  
  describe "Diploma Associations" do
    
    it "should have a diploma attribute" do
      @diploma_type.should respond_to(:diploma)  
    end
    
    it "should have the right associated diploma" do
      @diploma_type.diploma_id.should == @diploma.id
      @diploma_type.diploma.should == @diploma
    end    
  end
  
  describe "Validations" do
    
    it "should require a diploma id" do
      DiplomaType.new(@attr).should_not be_valid
    end
    
    it "should require a label" do
      invalid_diploma_type = DiplomaType.new(@attr.merge(:label => ''))
      invalid_diploma_type.should_not be_valid
    end
    
    it "should reject too short labels" do
      short_diploma_type = DiplomaType.new(@attr.merge(:label => 'xxxx'))
      short_diploma_type.should_not be_valid      
    end
    
    it "should reject too long labels" do
      long_label = 'a' * 31
      long_diploma_type = DiplomaType.new(@attr.merge(:label => long_label))
      long_diploma_type.should_not be_valid      
    end
  end
end
# == Schema Information
#
# Table name: diploma_types
#
#  id         :integer(4)      not null, primary key
#  label      :string(255)
#  diploma_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

