require 'spec_helper'

describe RelationshipsController do

  before :each do
    @candidate = Factory :candidate, :profile_completion => 5
    @recruiter = Factory :recruiter, :profile_completion => 5
    test_sign_in @recruiter
  end
  
  describe "POST 'create'" do
    
    it 'should respond http success' do
      xhr :post, :create, :user_id => @candidate.id
      response.should be_success
    end
        
    it 'should create a new relationship' do
      lambda do
        xhr :post, :create, :user_id => @candidate.id
      end.should change(Relationship, :count).by 1
    end
    
    it 'should add a followed user to the follower' do
      lambda do
        xhr :post, :create, :user_id => @candidate.id
      end.should change(@recruiter.followed_users, :count).by 1
    end
    
    it 'should add a follower to the followed user' do
      lambda do
        xhr :post, :create, :user_id => @candidate.id
      end.should change(@candidate.followers, :count).by 1
    end
  end
  
  describe "POST 'destroy'" do
    
    before :each do
      @recruiter.follow! @candidate
    end
    
    it 'should respond http success' do
      xhr :delete, :destroy, :user_id => @candidate.id
      response.should be_success
    end
        
    it 'should delete the relationship' do
      lambda do
        xhr :delete, :destroy, :user_id => @candidate.id
      end.should change(Relationship, :count).by -1
    end
    
    it 'should remove a followed user off the follower' do
      lambda do
        xhr :delete, :destroy, :user_id => @candidate.id
      end.should change(@recruiter.followed_users, :count).by -1
    end
    
    it 'should remove a follower off the followed user' do
      lambda do
        xhr :delete, :destroy, :user_id => @candidate.id
      end.should change(@candidate.followers, :count).by -1
    end
  end
end