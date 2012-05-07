require 'spec_helper'

describe Language do
  
  before :each do
    @attr               = { :label => 'French' }
    @language           = Factory :language
    @candidate          = Factory :candidate
    @language_candidate = Factory :language_candidate, :candidate => @candidate, :language => @language
  end
  
  it 'should create an instance given valid attributes' do
    Language.new(@attr).should be_valid
  end
  
  describe 'language_candidates associations' do
    
    it { @language.should respond_to :language_candidates }
    
    it 'should destroy associated language_candidates' do
      @language.destroy
      LanguageCandidate.find_by_id(@language_candidate.id).should be_nil
    end
  end
  
  describe 'candidates associations' do
    
    it { @language.should respond_to :candidates }
    
    it 'should not destroy associated candidates' do
      @language.destroy
      Candidate.find_by_id(@candidate.id).should_not be_nil
    end
  end
  
  describe 'validations' do
    it { should validate_presence_of :label }
    it { should ensure_length_of(:label).is_at_most 80 }
  end
end

# == Schema Information
#
# Table name: languages
#
#  id         :integer(4)      not null, primary key
#  label      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

