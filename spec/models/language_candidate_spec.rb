require 'spec_helper'

describe LanguageCandidate do

  before :each do
    @attr       = { :level => 'fluent' }
    @candidate  = Factory :candidate
    @language   = Factory :language
    @language_c = Factory :language_candidate, :candidate => @candidate, :language => @language
  end
  
  it 'should create an instance given valid attributes' do
    language_c = LanguageCandidate.new @attr ; language_c.candidate = @candidate ; language_c.language = @language
    language_c.should be_valid
  end
  
  describe 'language associations' do
    
    it { @language_c.should respond_to :language }
    
    it 'should have the right associated language' do
      @language_c.language_id.should == @language.id
      @language_c.language.should    == @language
    end    
    
    it 'should not destroy the associated language' do
      @language_c.destroy
      Language.find_by_id(@language.id).should_not be_nil
    end
  end
  
  describe 'candidate associations' do
    
    it { @language_c.should respond_to :candidate }
    
    it 'should have the right associated candidate' do
      @language_c.candidate_id.should == @candidate.id
      @language_c.candidate.should    == @candidate
    end
    
    it 'should not destroy the associated candidate' do
      @language_c.destroy
      Candidate.find_by_id(@candidate.id).should_not be_nil
    end
  end
  
  describe 'validations' do
    
    before :all do
      @level = { :valid => [ 'beginner', 'intermediate', 'fluent', 'native' ], :invalid => [ 'pouet', 'invalid_level', '45346', '...' ] }
    end
    
    it { should validate_presence_of :language }
    it { should validate_presence_of :candidate }
    it { should validate_presence_of :level }
    it { should validate_format_of(:level).not_with(@level[:invalid]).with_message(I18n.t('activerecord.errors.messages.inclusion')) }
    it { should validate_format_of(:level).with(@level[:valid]) }
  end
end

# == Schema Information
#
# Table name: language_candidates
#
#  id           :integer(4)      not null, primary key
#  language_id  :integer(4)
#  candidate_id :integer(4)
#  level        :string(255)
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

