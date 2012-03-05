require 'spec_helper'

describe LanguageCandidate do

  before :each do
    @attr               = { :level => 'fluent' }
    @candidate          = Factory :candidate
    @language           = Factory :language
    @language_candidate = Factory :language_candidate, :candidate => @candidate, :language => @language
  end
  
  it 'should create an instance given valid attributes' do
    language_candidate = LanguageCandidate.new @attr ; language_candidate.candidate = @candidate ; language_candidate.language = @language
    language_candidate.should be_valid
  end
  
  describe 'language associations' do
    
    it 'should have a language attribute' do
      @language_candidate.should respond_to :language
    end
    
    it 'should have the right associated language' do
      @language_candidate.language_id.should == @language.id
      @language_candidate.language.should == @language
    end    
    
    it 'should not destroy the associated language' do
      @language_candidate.destroy
      Language.find_by_id(@language.id).should_not be_nil
    end
  end
  
  describe 'candidate associations' do
    
    it 'should have a candidate attribute' do
      @language_candidate.should respond_to :candidate
    end
    
    it 'should have the right associated candidate' do
      @language_candidate.candidate_id.should == @candidate.id
      @language_candidate.candidate.should == @candidate
    end
    
    it 'should not destroy the associated candidate' do
      @language_candidate.destroy
      Candidate.find_by_id(@candidate.id).should_not be_nil
    end
  end
  
  describe 'validations' do
    
    it 'should require a language id' do
      @language.language_candidates.build(@attr).should_not be_valid
    end
    
    it 'should require a candidate id' do
      @candidate.language_candidates.build(@attr).should_not be_valid
    end
    
    it 'should require a level' do
      language_candidate = LanguageCandidate.new :level => '' ; language_candidate.language = @language ; language_candidate.candidate = @candidate
      language_candidate.should_not be_valid
    end
    
    it 'should reject invalid levels' do
      invalid_levels = [ 'pouet', 'invalid_level', '45346', '...' ]
      invalid_levels.each do |invalid_level|
        invalid_level_language_candidate = LanguageCandidate.new :level => invalid_level ; invalid_level_language_candidate.language = @language ; invalid_level_language_candidate.candidate = @candidate
        invalid_level_language_candidate.should_not be_valid
      end
    end
    
    it 'should accept a valid levels' do
      valid_levels = [ 'beginner', 'intermediate', 'fluent', 'native' ]
      valid_levels.each do |valid_level|
        valid_level_language_candidate = LanguageCandidate.new :level => valid_level ; valid_level_language_candidate.candidate = @candidate ; valid_level_language_candidate.language = @language
        valid_level_language_candidate.should be_valid
      end
    end
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
#  created_at   :datetime
#  updated_at   :datetime
#

