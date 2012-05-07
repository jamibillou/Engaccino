require 'spec_helper'

describe Relationship do
  
  before :each do
    @follower = Factory :recruiter
    @followed = Factory :candidate
    @attr     = { :followed_id => @followed.id }
  end
  
  it 'should create an instance given valid attributes' do
    @follower.relationships.create!(@attr).should be_valid
  end
  
  describe 'users associations' do
    
    before :each do
      @relationship = @follower.relationships.create! @attr
    end
    
    it 'should have the right associated follower' do
      @relationship.follower_id.should == @follower.id
    end
    
    it 'should have the right associated followed user' do
      @relationship.followed_id.should == @followed.id
    end
    
    it 'should not destroy the associated users' do
      @relationship.destroy
      Recruiter.find_by_id(@follower.id).should_not be_nil
      Candidate.find_by_id(@followed.id).should_not be_nil
    end
  end
  
  describe 'validations' do
    it { should validate_presence_of :follower_id }
    it { should validate_presence_of :followed_id }
  end
end

# == Schema Information
#
# Table name: relationships
#
#  id          :integer(4)      not null, primary key
#  follower_id :integer(4)
#  followed_id :integer(4)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#