require 'spec_helper'

describe Candidate do
  
  before :each do
    @attr = { :first_name    => 'Juan',           :last_name      => 'Pablo',          :city                  => 'Madrid', :country => 'Spain',
              :nationality   => 'Spain',          :year_of_birth  => 1984,             :phone                 => '+34 6 88888888',
              :email         => 'jp@example.net', :facebook_login => 'jp@example.net', :linkedin_login        => 'jp@example.net',
              :twitter_login => '@j_pablo',       :password       => 'pouetpouet38',   :password_confirmation => 'pouetpouet38',
              :status => 'available' }
    @candidate                      = Factory :candidate
    @experience                     = Factory :experience, :candidate => @candidate
    @education                      = Factory :education,  :candidate => @candidate
    @language                       = Factory :language
    @language_candidate             = Factory :language_candidate, :candidate => @candidate, :language => @language
    @certificate                    = Factory :certificate
    @certificate_candidate          = Factory :certificate_candidate, :candidate => @candidate, :certificate => @certificate
    @professional_skill             = Factory :professional_skill
    @interpersonal_skill            = Factory :interpersonal_skill
    @professional_skill_candidate   = Factory :professional_skill_candidate,  :candidate => @candidate, :professional_skill  => @professional_skill
    @interpersonal_skill_candidate  = Factory :interpersonal_skill_candidate, :candidate => @candidate, :interpersonal_skill => @interpersonal_skill
  end
    
  it 'should create a new instance given valid attributes' do
    candidate = Candidate.create! @attr
    candidate.should be_valid
  end
  
  describe 'validations' do
       
    it 'should reject blank statuses' do
      candidate = Candidate.new @attr.merge :status => ''
      candidate.should_not be_valid
    end
    
    it 'should reject invalid statuses' do
      invalid_statuses = [ 'pouet', 'invalid_status', '45346', '...' ]
      invalid_statuses.each do |invalid_status|
        candidate = Candidate.new @attr.merge :status => invalid_status
        candidate.should_not be_valid
      end
    end
    
    it 'should accept valid statuses' do
      valid_statuses = [ 'available', 'looking', 'open', 'listening', 'happy' ]
      valid_statuses.each do |valid_status|
        candidate = Candidate.new @attr.merge :status => valid_status
        candidate.should be_valid
      end
    end
  end
  
  describe 'main_education attribute' do
  
    it 'should exist' do
      @candidate.should respond_to :main_education
    end
    
    it 'be nil if there is no education' do
      candidate = Factory :candidate
      candidate.main_education.should be_nil
    end

    it "should be the last education unless the candidate chose otherwise" do
      education2 = Education.new(:start_month => 1, :start_year => 1990, :end_month => 2, :end_year => 1992, :role => 'Sales administrator')
      school = School.new(:name => 'School') ; degree = Degree.new(:label => 'Degree') ; degree_type = DegreeType.new(:label => 'Degree type')

    it 'should be the last education unless the canddiate chose otherwise' do
      education2 = Education.new :start_month => 1, :start_year => 1990, :end_month => 2, :end_year => 1992
      school = School.new :name => 'School' ; degree = Degree.new :label => 'Degree' ; degree_type = DegreeType.new :label => 'Degree type'
      education2.school = school ; education2.degree = degree ; degree.degree_type = degree_type ; education2.candidate = @candidate ; education2.save!
      @candidate.main_education.should == @candidate.last_education.id
    end
  end
  
  describe 'main_experience attribute' do
  
    it 'should exist' do
      @candidate.should respond_to :main_experience
    end
    
    it 'be nil if there is no experience' do
      candidate = Factory :candidate
      candidate.main_experience.should be_nil
    end
    
    it 'should be the last experience unless the canddiate chose otherwise' do
      experience2 = Experience.new :start_month => 1, :start_year => 1990, :end_month => 2, :end_year => 1992, :role => 'Sales administrator'
      company = Company.new :name => 'Company' ; experience2.company = company ; experience2.candidate = @candidate ; experience2.save!
      @candidate.main_experience.should == @candidate.last_experience.id
    end
  end
  
  describe 'experiences associations' do
  
    it 'should have an experiences attribute' do
      @candidate.should respond_to :experiences
    end
    
    it 'should destroy associated experiences' do
      @candidate.destroy
      Experience.find_by_id(@experience.id).should be_nil
    end
  end
  
  describe 'educations associations' do
    
    it 'should have an educations attribute' do
      @candidate.should respond_to :educations
    end
    
    it 'should destroy associated educations' do
      @candidate.destroy
      Education.find_by_id(@education.id).should be_nil
    end
  end
  
  describe 'language_candidates associations' do
    
    it 'should have a language_candidates attribute' do
      @candidate.should respond_to :language_candidates
    end
    
    it 'should destroy associated language_candidates' do
      @candidate.destroy
      LanguageCandidate.find_by_id(@language_candidate.id).should be_nil
    end
  end
  
  describe 'certificate_candidates associations' do
    
    it 'should have a certificate_candidates attribute' do
      @candidate.should respond_to :certificate_candidates
    end
    
    it 'should destroy associated certificate_candidates' do
      @candidate.destroy
      CertificateCandidate.find_by_id(@certificate_candidate.id).should be_nil
    end
  end
  
  describe 'professional_skill_candidates associations' do
    
    it 'should have a professional_skill_candidates attribute' do
      @candidate.should respond_to :professional_skill_candidates
    end
    
    it 'should destroy associated professional_skill_candidates' do
      @candidate.destroy
      ProfessionalSkillCandidate.find_by_id(@professional_skill_candidate.id).should be_nil
    end
  end

  describe 'interpersonal_skill_candidates associations' do
    
    it 'should have a interpersonal_skill_candidates attribute' do
      @candidate.should respond_to :interpersonal_skill_candidates
    end
    
    it 'should destroy associated interpersonal_skill_candidates' do
      @candidate.destroy
      InterpersonalSkillCandidate.find_by_id(@interpersonal_skill_candidate.id).should be_nil
    end
  end
  
  describe 'timeline_duration method' do
    
    it 'should exist' do
      @candidate.should respond_to :timeline_duration
    end
    
    it 'should be nil for candidates without events' do
      candidate = Factory :candidate
      candidate.timeline_duration.should be_nil
    end
    
    it 'should equal the difference between the start date of the first event and the end date of the last event' do 
      @candidate.timeline_duration.should == @candidate.last_event.end_year - @candidate.first_event.start_year - 1 + (13 - @candidate.first_event.start_month +  @candidate.last_event.end_month) / 12.0
    end
    
    it 'should equal the duration of the single event for candidates with only one event' do 
      @education.destroy
      @candidate.timeline_duration.should == @experience.duration
    end
  end
  
  describe 'experience_duration method' do
    
    it 'should be nil for candidates without experience' do
      @experience.destroy
      @candidate.experience_duration.should be_nil
    end
    
    it 'should equal the duration of the single experience for candidates with only one experience' do
      @candidate.experience_duration.should == @experience.duration
    end
    
    it 'should equal the difference between the start date of the first experience and the end date of the last experience' do
      experience2 = Experience.new :start_month => 1, :start_year => 1990, :end_month => 2, :end_year => 1992, :role => 'Sales administrator'
      company = Company.new :name => 'Company' ; experience2.company = company ; experience2.candidate = @candidate ; experience2.save!
      @candidate.experience_duration.should == @candidate.last_experience.end_year - @candidate.first_experience.start_year - 1 + (13 - @candidate.first_experience.start_month + @candidate.last_experience.end_month) / 12.0
    end
    
    it 'should equal the timeline_duration for candidates without education' do
      experience2 = Experience.new :start_month => 1, :start_year => 1990, :end_month => 2, :end_year => 1992, :role => 'Sales administrator'
      company = Company.new :name => 'Company' ; experience2.company = company ; experience2.candidate = @candidate ; experience2.save!
      @education.destroy
      @candidate.experience_duration.should == @candidate.timeline_duration
    end
  end
  
  describe 'longest_event method' do
    
    it 'should exist' do
      @candidate.should respond_to :longest_event
    end
    
    it 'should be nil for candidates with neither experience nor education' do
      @experience.destroy ; @education.destroy
      @candidate.longest_event.should be_nil
    end
    
    it 'should be the single event for candidates with only one event' do
      @experience.destroy
      @candidate.longest_event.should == @education
    end
    
    it 'should be the longest event' do
      @candidate.longest_event.should == @experience
    end
  end
  
  describe 'longest(collection) method' do
    
    it 'should exist' do
      @candidate.should respond_to :longest
    end
    
    it 'should be nil for candidates for an empty collection' do
      @experience.destroy ;
      @candidate.longest(@candidate.experiences).should be_nil
    end
    
    it 'should be the single event of the collection when there is only one in it' do
      @candidate.longest(@candidate.experiences).should == @experience
      @candidate.longest(@candidate.educations).should  == @education
    end
    
    it 'should be the longest event of the collection' do
      longest_experience = Experience.new :start_month => 1, :start_year => 1990, :end_month => 2, :end_year => 2010, :role => 'Sales administrator'
      company = Company.new :name => 'Company' ; longest_experience.company = company ; longest_experience.candidate = @candidate ; longest_experience.save!
      @candidate.longest(@candidate.experiences).should == longest_experience
    end
  end
  
  describe 'first_event method' do
    
    it 'should be nil for candidates with neither experience nor education' do
      @experience.destroy ; @education.destroy
      @candidate.first_event.should be_nil
    end
    
    it 'should be the single event for candidates with only one event' do 
      @experience.destroy
      @candidate.first_event.should == @education
    end
    
    it 'should be the first event' do
      @candidate.first_event.should == @experience
    end
  end
  
  describe 'first_experience method' do
    
    it 'should be nil for candidates with no experience' do
      @experience.destroy
      @candidate.first_experience.should be_nil
    end
    
    it 'should be the first experience' do
      experience2 = Experience.new :start_month => 1, :start_year => 1990, :end_month => 2, :end_year => 1992, :role => 'Sales administrator'
      company = Company.new :name => 'Company' ; experience2.company = company ; experience2.candidate = @candidate ; experience2.save!
      @candidate.first_experience.should == experience2
    end
  end
  
  describe 'first_education method' do
    
    it 'should be nil for candidates with no education' do
      @education.destroy
      @candidate.first_education.should be_nil
    end
    
    it 'should be the first education' do
      education2 = Education.new :start_month => 1, :start_year => 1990, :end_month => 2, :end_year => 1992
      school = School.new :name => 'School' ; degree = Degree.new :label => 'Degree' ; degree_type = DegreeType.new :label => 'Degree type'
      education2.school = school ; education2.degree = degree ; degree.degree_type = degree_type ; education2.candidate = @candidate ; education2.save!
      @candidate.first_education.should == education2
    end
  end
  
  describe 'last_event method' do
    
    it 'should be nil for candidates with neither experience nor education' do
      @experience.destroy ; @education.destroy
      @candidate.first_event.should be_nil
    end 
    
    it 'should be the single event for candidates with only one event' do 
      @education.destroy
      @candidate.last_event.should  == @experience
    end
    
    it 'should be the first event' do
      @candidate.last_event.should == @education
    end
  end
  
  describe 'last_experience method' do
    
    it 'should be nil for candidates with no experience' do
      @experience.destroy
      @candidate.last_experience.should be_nil
    end
    
    it 'should be the last experience' do
      experience2 = Experience.new :start_month => 1, :start_year => 1990, :end_month => 2, :end_year => 1992, :role => 'Sales administrator'
      company = Company.new :name => 'Company' ; experience2.company = company ; experience2.candidate = @candidate ; experience2.save!
      @candidate.last_experience.should == @experience
    end
  end
  
  describe 'last_education method' do
    
    it 'should be nil for candidates with no education' do
      @education.destroy
      @candidate.last_education.should be_nil
    end
    
    it 'should be the last education' do
      education2 = Education.new :start_month => 1, :start_year => 1990, :end_month => 2, :end_year => 1992
      school = School.new :name => 'School' ; degree = Degree.new :label => 'Degree' ; degree_type = DegreeType.new :label => 'Degree type'
      education2.school = school ; education2.degree = degree ; degree.degree_type = degree_type ; education2.candidate = @candidate ; education2.save!
      @candidate.last_education.should == @education
    end
  end
  
  describe 'no_exp? method' do
    
    it 'should be false for candidates with experience' do
      @candidate.no_exp?.should == false
    end
    
    it 'should be true for candidates without experience' do
      @experience.destroy
      @candidate.no_exp?.should == true
    end
  end
  
  describe 'no_edu? method' do
    
    it 'should be false for candidates with education' do
      @candidate.no_edu?.should == false
    end
    
    it 'should be true for candidates without education' do
      @education.destroy
      @candidate.no_edu?.should == true
    end
  end
  
  describe 'neither_exp_nor_edu? method' do
    
    it 'should be false for candidates with experience and education' do
      @candidate.neither_exp_nor_edu?.should == false
    end
    
    it 'should be false for candidates with experience and no education' do
      @education.destroy
      @candidate.neither_exp_nor_edu?.should == false
    end
    
    it 'should be false for candidates with education but no experience' do
      @experience.destroy
      @candidate.neither_exp_nor_edu?.should == false
    end
    
    it 'should be true for candidates without experience' do
      @education.destroy ; @experience.destroy
      @candidate.neither_exp_nor_edu?.should == true
    end
  end
    
  describe 'no_edu_but_exp? method' do
    
    it 'should be false for candidates with experience and education' do
      @candidate.no_edu_but_exp?.should == false
    end
    
    it 'should be false for candidates with education but no experience' do
      @experience.destroy
      @candidate.no_edu_but_exp?.should == false
    end
    
    it 'should be false for candidates without experience' do
      @education.destroy ; @experience.destroy
      @candidate.no_edu_but_exp?.should == false
    end
    
    it 'should be true for candidates with experience and no education' do
      @education.destroy
      @candidate.no_edu_but_exp?.should == true
    end
  end
    
  describe 'no_exp_but_edu? method' do
    
    it 'should be false for candidates with experience and education' do
      @candidate.no_exp_but_edu?.should == false
    end
    
    it 'should be false for candidates with experience and no education' do
      @education.destroy
      @candidate.no_exp_but_edu?.should == false
    end
    
    it 'should be false for candidates without experience' do
      @education.destroy ; @experience.destroy
      @candidate.no_exp_but_edu?.should == false
    end
    
    it 'should be true for candidates with education but no experience' do
      @experience.destroy
      @candidate.no_exp_but_edu?.should == true
    end
  end
    
  describe 'exp_and_edu? method' do
    
    it 'should be false for candidates with experience and no education' do
      @education.destroy
      @candidate.exp_and_edu?.should == false
    end
    
    it 'should be false for candidates with education but no experience' do
      @experience.destroy
      @candidate.exp_and_edu?.should == false
    end
    
    it 'should be false for candidates without experience' do
      @education.destroy ; @experience.destroy
      @candidate.exp_and_edu?.should == false
    end
    
    it 'should be true for candidates with experience and education' do
      @candidate.exp_and_edu?.should == true
    end
  end
  
  describe 'no_pro_skill? method' do
    
    it 'should be false for candidates with professional skills' do
      @candidate.no_pro_skill?.should == false
    end
    
    it 'should be true for candidates without professional skill' do
      @professional_skill_candidate.destroy
      @candidate.no_pro_skill?.should == true
    end
  end
  
  describe 'no_perso_skill? method' do
    
    it 'should be false for candidates with interpersonal skills' do
      @candidate.no_perso_skill?.should == false
    end
    
    it 'should be true for candidates without interpersonal skill' do
      @interpersonal_skill_candidate.destroy
      @candidate.no_perso_skill?.should == true
    end
  end
  
  describe 'no_certif? method' do
    
    it 'should be false for candidates with certificates' do
      @candidate.no_certif?.should == false
    end
    
    it 'should be true for candidates without certificate' do
      @certificate_candidate.destroy
      @candidate.no_certif?.should == true
    end
  end
  
  describe 'no_lang? method' do
    
    it 'should be false for candidates with languages' do
      @candidate.no_lang?.should == false
    end
    
    it 'should be true for candidates without language' do
      @language_candidate.destroy
      @candidate.no_lang?.should == true
    end
  end
  
  describe 'no_social? method' do
    
    it 'should be false for candidates with all social networks' do
      @candidate.no_social?.should == false
    end
    
    it 'should be false for candidates with some social networks' do
      @candidate.update_attributes :facebook_login => ''
      @candidate.no_social?.should == false
      @candidate.update_attributes :twitter_login => ''
      @candidate.no_social?.should == false
    end
    
    it 'should be true for candidates without social networks' do
      @candidate.update_attributes :facebook_login => '', :linkedin_login => '', :twitter_login => ''
      @candidate.no_social?.should == true
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

