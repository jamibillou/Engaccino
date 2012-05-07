require 'spec_helper'

describe InterpersonalSkillCandidate do
  
  before :each do
    @attr          = { :description => 'It is basically a fantastic skill which makes me very proud' }
    @candidate     = Factory :candidate
    @perso_skill   = Factory :interpersonal_skill 
    @perso_skill_c = Factory :interpersonal_skill_candidate, :candidate => @candidate, :interpersonal_skill => @perso_skill
  end
  
  it 'should create an instance given valid attributes' do
    perso_skill_c = InterpersonalSkillCandidate.new @attr ; perso_skill_c.candidate = @candidate ; perso_skill_c.interpersonal_skill = @perso_skill
    perso_skill_c.should be_valid
  end
  
  describe 'candidate associations' do
  
    it { @perso_skill_c.should respond_to :candidate }
    
    it 'should have the right associated candidate' do
      @perso_skill_c.candidate_id.should == @candidate.id
      @perso_skill_c.candidate.should    == @candidate
    end
    
    it 'should not destroy the associated candidate' do
      @perso_skill_c.destroy
      Candidate.find(@candidate).should_not be_nil
    end
  end
  
  describe 'interpersonal_skill associations' do
  
    it { @perso_skill_c.should respond_to :interpersonal_skill }
    
    it 'should have the right associated interpersonal_skill' do
      @perso_skill_c.interpersonal_skill_id.should == @perso_skill.id
      @perso_skill_c.interpersonal_skill.should    == @perso_skill
    end
    
    it 'should not destroy the associated interpersonal_skill' do
      @perso_skill_c.destroy
      InterpersonalSkill.find(@perso_skill).should_not be_nil
    end
  end
  
  describe 'validations' do
    it { should_not validate_presence_of :description }
    it { should ensure_length_of(:description).is_at_least(20).is_at_most 160 }
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
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#

