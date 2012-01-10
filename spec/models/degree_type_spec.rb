require 'spec_helper'

describe DegreeType do

  before(:each) do
    @attr = { :label => "IUT" }
    @degree_type = Factory(:degree_type)
  end

  it "should create an instance given valid attributes" do
    degree_type = DegreeType.new(@attr)
    degree_type.save!
    degree_type.should be_valid
  end
  
  describe "degree associations" do
    
    it "should have an degree attribute" do
      @degree_type.should respond_to(:degrees)
    end
    
    it "should not destroy associated degrees" do
      @degree = Factory(:degree, :degree_type_id => @degree_type)
      @degree_type.destroy
      Degree.find_by_id(@degree.id).should_not be_nil
    end
  end
  
  describe "validations" do
        
    it "should require a label" do
      invalid_degree_type = DegreeType.new(@attr.merge(:label => ''))
      invalid_degree_type.should_not be_valid
    end
    
    it "should reject too short labels" do
      short_degree_type = DegreeType.new(@attr.merge(:label => 'x'))
      short_degree_type.should_not be_valid      
    end
    
    it "should reject too long labels" do
      long_label = 'a' * 31
      long_degree_type = DegreeType.new(@attr.merge(:label => long_label))
      long_degree_type.should_not be_valid      
    end
  end
end
# == Schema Information
#
# Table name: degree_types
#
#  id         :integer(4)      not null, primary key
#  label      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

