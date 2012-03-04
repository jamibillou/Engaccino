require 'spec_helper'

describe LanguageCandidateObserver do
  
  before(:each) do
    @candidate = Factory(:candidate)
    @language  = Factory(:language)
  end
  
  describe "update_profile_completion_create method" do
    
    it "should increase the profile completion by 5 when candidates with no language add one" do
      before_profile_completion_update = @candidate.profile_completion
      language_candidate = LanguageCandidate.new(:label => 'Language', :level => 'beginner')
      language_candidate.candidate = @candidate ; language_candidate.language = @language ; language_candidate.save!
      @candidate.profile_completion.should == before_profile_completion_update + 5
    end
    
    it "should not increase the profile completion when candidates with 1 or more languages add a new one" do
      language_candidate = LanguageCandidate.new(:label => 'Language',   :level => 'beginner')
      language_candidate.candidate = @candidate ;  language_candidate.language = @language ;  language_candidate.save!
      before_profile_completion_update = @candidate.profile_completion
      language_candidate2 = LanguageCandidate.new(:label => 'Language 2', :level => 'fluent')
      language_candidate2.candidate = @candidate ; language_candidate2.language = @language ; language_candidate2.save!
      @candidate.profile_completion.should == before_profile_completion_update
    end
  end
  
  describe "update_profile_completion_destroy method" do
    
    before(:each) do
      @language_candidate = LanguageCandidate.new(:label => 'Language', :level => 'beginner')
      @language_candidate.candidate = @candidate ; @language_candidate.language = @language ; @language_candidate.save!
    end
    
    it "should decrease the profile completion by 5 when candidates with 1 language delete it" do
      before_profile_completion_update = @candidate.profile_completion
      @language_candidate.destroy
      @candidate.profile_completion.should == before_profile_completion_update - 5
    end
    
    it "should not decrease the profile completion when candidates with more than 1 language delete one" do
      language_candidate2 = LanguageCandidate.new(:label => 'Language 2', :level => 'fluent')
      language_candidate2.candidate = @candidate ; language_candidate2.language = @language ; language_candidate2.save!
      before_profile_completion_update = @candidate.profile_completion
      language_candidate2.destroy
      @candidate.profile_completion.should == before_profile_completion_update
    end   
  end
end
