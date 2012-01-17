require 'spec_helper'

describe Language do
  
  before(:each) do
    @attr = {:label => "French"}
    @language = Factory(:language)
    @candidate = Factory(:candidate)
    @language_candidate = Factory(:language_candidate, :candidate => @candidate, :language => @language)
  end
  
  it "should create an instance given valid attributes" do
    language = Language.create!(@attr)
    language.should be_valid
  end
  
  describe "language_candidates associations" do
    
    it "should have a language_candidates attributes" do
      @language.should respond_to :language_candidates
    end
    
    it "should destroy associated language_candidates" do
      @language.destroy
      LanguageCandidate.find_by_id(@language_candidate.id).should be_nil
    end
  end
  
  describe "validations" do
    
    it "should require a label" do
      empty_label_language = Language.new(@attr.merge(:label => ""))
      empty_label_language.should_not be_valid
    end
    
    it "should reject too short labels" do
      too_short_label = 'a'
      too_short_label_language = Language.new(@attr.merge(:label => too_short_label))
      too_short_label_language.should_not be_valid
    end
    
    it "should reject too long labels" do
      too_long_label = 'a'*81
      too_long_label_language = Language.new(@attr.merge(:label => too_long_label))
      too_long_label_language.should_not be_valid
    end
    
  end
  
end
# == Schema Information
#
# Table name: languages
#
#  id           :integer(4)      not null, primary key
#  name         :string(255)
#  candidate_id :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

