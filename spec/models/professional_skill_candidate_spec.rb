require 'spec_helper'

describe ProfessionalSkillCandidate do
  
  before :each do
    @attr        = { :description => 'It is basically a fantastic skill which makes me quite proud', :experience => '3', :level => 'expert' }
    @candidate   = Factory :candidate
    @pro_skill   = Factory :professional_skill
    @pro_skill_c = Factory :professional_skill_candidate, :candidate => @candidate, :professional_skill => @pro_skill
  end
  
  it 'should create an instance given valid attributes' do
    pro_skill_c = ProfessionalSkillCandidate.new @attr ; pro_skill_c.candidate = @candidate ; pro_skill_c.professional_skill = @pro_skill
    pro_skill_c.should be_valid
  end
  
  describe 'candidate associations' do
  
    it { @pro_skill_c.should respond_to :candidate }
    
    it 'should have the right associated candidate' do
      @pro_skill_c.candidate_id.should == @candidate.id
      @pro_skill_c.candidate.should    == @candidate
    end
    
    it 'should not destroy associated candidate' do
      @pro_skill_c.destroy
      Candidate.find_by_id(@candidate.id).should_not be_nil
    end
  end
  
  describe 'professional_skill associations' do
  
    it { @pro_skill_c.should respond_to :professional_skill }
    
    it 'should have the right associated professional_skill' do
      @pro_skill_c.professional_skill_id.should == @pro_skill.id
      @pro_skill_c.professional_skill.should    == @pro_skill
    end
    
    it 'should not destroy associated professional_skill' do
      @pro_skill_c.destroy
      ProfessionalSkill.find_by_id(@pro_skill.id).should_not be_nil
    end
  end
  
  describe 'validations' do
    
    before :all do
      @level = { :valid => [ 'beginner', 'intermediate', 'fluent', 'native' ], :invalid => [ 'pouet', 'invalid_level', '45346', '...' ] }
      @exp   = { :valid => [ 1, 5, 25, 38, 46, 59 ],                           :invalid => [ 'pouet', 'invalid_experience', '45346', '...' ] }
    end
    
    it { should validate_presence_of :level }
    it { should validate_format_of(:level).not_with(@level[:invalid]).with_message(I18n.t('activerecord.errors.messages.inclusion')) }
    it { should validate_format_of(:level).with(@level[:valid]) }
    
    it { should_not validate_presence_of :description }
    it { should ensure_length_of(:description).is_at_least(20).is_at_most 160 }
    
    it { should validate_presence_of :experience }
    # it { should validate_format_of(:experience).not_with(@exp[:invalid]).with_message(I18n.t('activerecord.errors.messages.inclusion')) }
    it { should validate_format_of(:experience).with(@exp[:valid]) }
  end
end

# == Schema Information
#
# Table name: professional_skill_candidates
#
#  id                    :integer(4)      not null, primary key
#  level                 :string(255)
#  experience            :integer(4)
#  description           :string(255)
#  candidate_id          :integer(4)
#  professional_skill_id :integer(4)
#  created_at            :datetime        not null
#  updated_at            :datetime        not null
#

