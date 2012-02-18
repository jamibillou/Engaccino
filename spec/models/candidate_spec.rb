require 'spec_helper'

describe Candidate do
  
  before(:each) do
    @attr = {
      :first_name => "Juan",
      :last_name => "Pablo",
      :city => "Madrid",         
      :country => "Spain",
      :nationality => "Spain",
      :year_of_birth => 1984,
      :phone => "+34 6 88888888",
      :email => "jp@example.net",
      :facebook_login => "jp@example.net",
      :linkedin_login => "jp@example.net",
      :twitter_login => "@j_pablo",
      :password => "pouetpouet38",
      :password_confirmation => "pouetpouet38",
      :status => 'available'
    }
    @candidate                      = Factory(:candidate) 
    @experience                     = Factory(:experience, :candidate => @candidate)
    @education                      = Factory(:education, :candidate => @candidate) 
    @language                       = Factory(:language)
    @language_candidate             = Factory(:language_candidate, :candidate => @candidate, :language => @language)
    @certificate                    = Factory(:certificate)
    @certificate_candidate          = Factory(:certificate_candidate, :candidate => @candidate, :certificate => @certificate)
    @professional_skill             = Factory(:professional_skill)
    @interpersonal_skill            = Factory(:interpersonal_skill)
    @professional_skill_candidate   = Factory(:professional_skill_candidate,  :candidate => @candidate, :professional_skill  => @professional_skill)
    @interpersonal_skill_candidate  = Factory(:interpersonal_skill_candidate, :candidate => @candidate, :interpersonal_skill => @interpersonal_skill)
  end
    
  it "should create a new instance given valid attributes" do
    candidate = Candidate.create!(@attr)
    candidate.should be_valid
  end
  
  describe "validations" do
       
    it "should reject blank statuses" do
      candidate = Candidate.new(@attr.merge(:status => ''))
      candidate.should_not be_valid
    end
    
    it "should reject invalid statuses" do
      invalid_statuses = [ 'pouet', 'invalid_status', '45346', '...' ]
      invalid_statuses.each do |invalid_status|
        candidate = Candidate.new(@attr.merge(:status => invalid_status))
        candidate.should_not be_valid
      end
    end
    
    it "should accept valid statuses" do
      valid_statuses = [ 'available', 'looking', 'open', 'listening', 'happy' ]
      valid_statuses.each do |valid_status|
        candidate = Candidate.new(@attr.merge(:status => valid_status))
        candidate.should be_valid
      end
    end
  end
  
  describe "experiences associations" do
  
    it "should have an experiences attribute" do
      @candidate.should respond_to(:experiences)
    end
    
    it "should destroy associated experiences" do
      @candidate.destroy
      Experience.find_by_id(@experience.id).should be_nil
    end
  end
  
  describe "educations associations" do
    
    it "should have an educations attribute" do
      @candidate.should respond_to(:educations)
    end
    
    it "should destroy associated educations" do
      @candidate.destroy
      Education.find_by_id(@education.id).should be_nil
    end
  end
  
  describe "language_candidates associations" do
    
    it "should have a language_candidates attribute" do
      @candidate.should respond_to(:language_candidates)
    end
    
    it "should destroy associated language_candidates" do
      @candidate.destroy
      LanguageCandidate.find_by_id(@language_candidate.id).should be_nil
    end
  end
  
  describe "certificate_candidates associations" do
    
    it "should have a certificate_candidates attribute" do
      @candidate.should respond_to(:certificate_candidates)
    end
    
    it "should destroy associated certificate_candidates" do
      @candidate.destroy
      CertificateCandidate.find_by_id(@certificate_candidate.id).should be_nil
    end
  end
  
  describe "professional_skill_candidates associations" do
    
    it "should have a professional_skill_candidates attribute" do
      @candidate.should respond_to(:professional_skill_candidates)
    end
    
    it "should destroy associated professional_skill_candidates" do
      @candidate.destroy
      ProfessionalSkillCandidate.find_by_id(@professional_skill_candidate.id).should be_nil
    end
  end

  describe "interpersonal_skill_candidates associations" do
    
    it "should have a interpersonal_skill_candidates attribute" do
      @candidate.should respond_to(:interpersonal_skill_candidates)
    end
    
    it "should destroy associated interpersonal_skill_candidates" do
      @candidate.destroy
      InterpersonalSkillCandidate.find_by_id(@interpersonal_skill_candidate.id).should be_nil
    end
  end
  
  describe "timeline_duration method" do
    
    it "should exist" do
      @candidate.should respond_to(:timeline_duration)
    end
    
    it "should be nil for candidates without events" do
      candidate = Factory(:candidate)
      candidate.timeline_duration.should be_nil
    end
    
    it "should equal the duration of the event for candidates with only one event" do 
    
    end
    
    it "should equal the difference between the start date of the first event and the end date of the last event" do 
    
    end
  end
  
  describe "experience_duration method" do
    
    it "should exist" do
      @candidate.should respond_to(:experience_duration)
    end
    
    it "should" do
    
    end
    
    it "should" do
    
    end
  end
  
  describe "long_timeline? method" do
    
    it "should exist" do
      @candidate.should respond_to(:long_timeline?)
    end
    
    it "should" do
    
    end
    
    it "should" do
    
    end
  end
  
  describe "longest_event method" do
    
    it "should exist" do
      @candidate.should respond_to(:longest_event)
    end
    
    it "should" do
    
    end
    
    it "should" do
    
    end
  end
  
  describe "first_event method" do
    
    it "should exist" do
      @candidate.should respond_to(:first_event)
    end
    
    it "should" do
    
    end
    
    it "should" do
    
    end
  end
  
  describe "last_event method" do
    
    it "should exist" do
      @candidate.should respond_to(:last_event)
    end
    
    it "should" do
    
    end
    
    it "should" do
    
    end
  end
  
  describe "longest(collection) method" do
    
    it "should exist" do
      @candidate.should respond_to(:longest)
    end
    
    it "should" do
    
    end
    
    it "should" do
    
    end
  end
  
  describe "first(collection) method" do
    
    it "should exist" do
      @candidate.should respond_to(:first)
    end
    
    it "should" do
    
    end
    
    it "should" do
    
    end
  end 
  
  describe "last(collection) method" do
    
    it "should exist" do
      @candidate.should respond_to(:last)
    end
    
    it "should" do
    
    end
    
    it "should" do
    
    end
  end 
  
  describe "main_education attribute" do
  
    it "should exist" do
      @candidate.should respond_to(:main_education)
    end
    
    it "return nil if there is no education" do
      candidate = Factory(:candidate)
      candidate.main_education.should be_nil
    end
  end
  
  describe "main_experience attribute" do
  
    it "should exist" do
      @candidate.should respond_to(:main_experience)
    end
    
    it "return nil if there is no experience" do
      candidate = Factory(:candidate)
      candidate.main_experience.should be_nil
    end
  end
  
end

# == Schema Information
#
# Table name: users
#
#  id                 :integer(4)      not null, primary key
#  first_name         :string(255)
#  last_name          :string(255)
#  city               :string(255)
#  country            :string(255)
#  nationality        :string(255)
#  year_of_birth      :integer(4)
#  phone              :string(255)
#  email              :string(255)
#  facebook_login     :string(255)
#  linkedin_login     :string(255)
#  twitter_login      :string(255)
#  status             :string(255)
#  type               :string(255)
#  facebook_connect   :boolean(1)      default(FALSE)
#  linkedin_connect   :boolean(1)      default(FALSE)
#  twitter_connect    :boolean(1)      default(FALSE)
#  profile_completion :integer(4)      default(0)
#  admin              :boolean(1)      default(FALSE)
#  salt               :string(255)
#  encrypted_password :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  image              :string(255)
#  main_education     :integer(4)
#  main_experience    :integer(4)
#

