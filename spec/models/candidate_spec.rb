require 'spec_helper'

describe Candidate do
  
  before :each do
    @attr = { :first_name => 'Juan', :last_name => 'Pablo', :city => 'Madrid', :country => 'Spain', :nationality => 'Spain', :year_of_birth  => 1984, :phone => '+34 6 88888888', :email => 'jp@example.net',
              :facebook_login => 'jp@example.net', :linkedin_login => 'jp@example.net', :twitter_login => '@j_pablo', :password => 'pouetpouet38', :password_confirmation => 'pouetpouet38', :status => 'available' }
    @candidate                     = Factory :candidate
    @experience                    = Factory :experience,                    :candidate => @candidate
    @company                       = Factory :company
    @education                     = Factory :education,                     :candidate => @candidate
    @language                      = Factory :language
    @language_candidate            = Factory :language_candidate,            :candidate => @candidate, :language => @language
    @certificate                   = Factory :certificate
    @certificate_candidate         = Factory :certificate_candidate,         :candidate => @candidate, :certificate => @certificate
    @professional_skill            = Factory :professional_skill
    @interpersonal_skill           = Factory :interpersonal_skill
    @professional_skill_candidate  = Factory :professional_skill_candidate,  :candidate => @candidate, :professional_skill  => @professional_skill
    @interpersonal_skill_candidate = Factory :interpersonal_skill_candidate, :candidate => @candidate, :interpersonal_skill => @interpersonal_skill
  end
    
  it 'should create a new instance given valid attributes' do
    Candidate.create!(@attr).should be_valid
  end
  
  describe 'validations' do
    
    before :all do
      @status = { :invalid => ['pouet', 'invalid_status', '45346', '...'], :valid => ['available', 'looking', 'open', 'listening', 'happy'] }
    end
    
    it { should validate_presence_of :status }
    it { should validate_format_of(:status).not_with(@status[:invalid]).with_message(I18n.t('activerecord.errors.messages.inclusion')) }
    it { should validate_format_of(:status).with(@status[:valid]) }
  end
  
  describe 'main_education attribute' do
  
    it { @candidate.should respond_to :main_education }
    
    it 'be nil if there is no education' do
      Factory(:candidate).main_education.should be_nil
    end
  
    it 'should be the last education unless the canddiate chose otherwise' do
      @candidate.main_education.should == @candidate.last_education.id
    end
  end
  
  describe 'main_experience attribute' do
  
    it { @candidate.should respond_to :main_experience }
    
    it 'be nil if there is no experience' do
      Factory(:candidate).main_experience.should be_nil
    end
    
    it 'should be the last experience unless the canddiate chose otherwise' do
      @candidate.main_experience.should == @candidate.last_experience.id
    end
  end
  
  describe 'experiences associations' do
  
    it { @candidate.should respond_to :experiences }
    
    it 'should destroy associated experiences' do
      @candidate.destroy
      Experience.find_by_id(@experience.id).should be_nil
    end
  end
  
  describe 'educations associations' do
    
    it { @candidate.should respond_to :educations }
    
    it 'should destroy associated educations' do
      @candidate.destroy
      Education.find_by_id(@education.id).should be_nil
    end
  end
  
  describe 'language_candidates associations' do
    
    it { @candidate.should respond_to :language_candidates }
    
    it 'should destroy associated language_candidates' do
      @candidate.destroy
      LanguageCandidate.find_by_id(@language_candidate.id).should be_nil
    end
  end
  
  describe 'certificate_candidates associations' do
    
    it { @candidate.should respond_to :certificate_candidates }
    
    it 'should destroy associated certificate_candidates' do
      @candidate.destroy
      CertificateCandidate.find_by_id(@certificate_candidate.id).should be_nil
    end
  end
  
  describe 'professional_skill_candidates associations' do
    
    it { @candidate.should respond_to :professional_skill_candidates }
    
    it 'should destroy associated professional_skill_candidates' do
      @candidate.destroy
      ProfessionalSkillCandidate.find_by_id(@professional_skill_candidate.id).should be_nil
    end
  end

  describe 'interpersonal_skill_candidates associations' do
    
    it { @candidate.should respond_to :interpersonal_skill_candidates }
    
    it 'should destroy associated interpersonal_skill_candidates' do
      @candidate.destroy
      InterpersonalSkillCandidate.find_by_id(@interpersonal_skill_candidate.id).should be_nil
    end
  end
  
  describe 'timeline_duration method' do
    
    it { @candidate.should respond_to :timeline_duration }
    
    it 'should be nil for candidates without events' do
      Factory(:candidate).timeline_duration.should be_nil
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
      Factory :experience, :start_month => 1, :start_year => 1990, :end_month => 2, :end_year => 1992, :candidate => @candidate
      @candidate.experience_duration.should == @candidate.last_experience.end_year - @candidate.first_experience.start_year - 1 + (13 - @candidate.first_experience.start_month + @candidate.last_experience.end_month) / 12.0
    end
    
    it 'should equal the timeline_duration for candidates without education' do
      Factory :experience, :start_month => 1, :start_year => 1990, :end_month => 2, :end_year => 1992, :candidate => @candidate
      @education.destroy
      @candidate.experience_duration.should == @candidate.timeline_duration
    end
  end
  
  describe 'longest_event method' do
    
    it { @candidate.should respond_to :longest_event }
    
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
    
    it { @candidate.should respond_to :longest }
    
    it 'should be nil for an empty collection' do
      @experience.destroy ;
      @candidate.longest(@candidate.experiences).should be_nil
    end
    
    it 'should be the single event for single event collections' do
      @candidate.longest(@candidate.experiences).should == @experience
      @candidate.longest(@candidate.educations).should  == @education
    end
    
    it 'should be the longest event of the collection' do
      longest_experience = Factory :experience, :start_month => 1, :start_year => 1990, :end_month => 2, :end_year => 2010, :candidate => @candidate
      @candidate.longest(@candidate.experiences).should == longest_experience
    end
  end
  
  describe 'first_event method' do
    
    it { @candidate.should respond_to :first_event }
    
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
    
    it { @candidate.should respond_to :first_experience }
    
    it 'should be nil for candidates with no experience' do
      @experience.destroy
      @candidate.first_experience.should be_nil
    end
    
    it 'should be the first experience' do
      experience2 = Factory :experience, :start_month => 1, :start_year => 1990, :end_month => 2, :end_year => 1992, :candidate => @candidate
      @candidate.first_experience.should == experience2
    end
  end
  
  describe 'first_education method' do
    
    it { @candidate.should respond_to :first_education }
    
    it 'should be nil for candidates with no education' do
      @education.destroy
      @candidate.first_education.should be_nil
    end
    
    it 'should be the first education' do
      education2 = Factory :education, :start_month => 1, :start_year => 1990, :end_month => 2, :end_year => 1992, :candidate => @candidate
      @candidate.first_education.should == education2
    end
  end
  
  describe 'last_event method' do
    
    it { @candidate.should respond_to :last_event }
    
    it 'should be nil for candidates with neither experience nor education' do
      @experience.destroy ; @education.destroy
      @candidate.first_event.should be_nil
    end 
    
    it 'should be the single event for candidates with only one event' do 
      @education.destroy
      @candidate.last_event.should  == @experience
    end
    
    it 'should be the last event' do
      @candidate.last_event.should == @education
    end
  end
  
  describe 'last_experience method' do
    
    it { @candidate.should respond_to :last_experience }
    
    it 'should be nil for candidates with no experience' do
      @experience.destroy
      @candidate.last_experience.should be_nil
    end
    
    it 'should be the last experience' do
      experience2 = Factory :experience, :start_month => 1, :start_year => 1990, :end_month => 2, :end_year => 1992, :candidate => @candidate
      @candidate.last_experience.should == @experience
    end
  end
  
  describe 'last_education method' do
    
    it { @candidate.should respond_to :last_education }
    
    it 'should be nil for candidates with no education' do
      @education.destroy
      @candidate.last_education.should be_nil
    end
    
    it 'should be the last education' do
      education2 = Factory :education, :start_month => 1, :start_year => 1990, :end_month => 2, :end_year => 1992, :candidate => @candidate
      @candidate.last_education.should == @education
    end
  end
  
  describe 'no_exp? method' do
    
    it { @candidate.should respond_to :no_exp? }
    
    it 'should be false for candidates with experience' do
      @candidate.no_exp?.should == false
    end
    
    it 'should be true for candidates without experience' do
      @experience.destroy
      @candidate.no_exp?.should == true
    end
  end
  
  describe 'no_edu? method' do
    
    it { @candidate.should respond_to :no_edu? }
    
    it 'should be false for candidates with education' do
      @candidate.no_edu?.should == false
    end
    
    it 'should be true for candidates without education' do
      @education.destroy
      @candidate.no_edu?.should == true
    end
  end
  
  describe 'neither_exp_nor_edu? method' do
    
    it { @candidate.should respond_to :neither_exp_nor_edu? }
    
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
    
    it { @candidate.should respond_to :no_edu_but_exp? }
    
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
    
    it { @candidate.should respond_to :no_exp_but_edu? }
    
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
    
    it { @candidate.should respond_to :exp_and_edu? }
    
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
    
    it { @candidate.should respond_to :no_pro_skill? }
    
    it 'should be false for candidates with professional skills' do
      @candidate.no_pro_skill?.should == false
    end
    
    it 'should be true for candidates without professional skill' do
      @professional_skill_candidate.destroy
      @candidate.no_pro_skill?.should == true
    end
  end
  
  describe 'no_perso_skill? method' do
    
    it { @candidate.should respond_to :no_perso_skill? }
    
    it 'should be false for candidates with interpersonal skills' do
      @candidate.no_perso_skill?.should == false
    end
    
    it 'should be true for candidates without interpersonal skill' do
      @interpersonal_skill_candidate.destroy
      @candidate.no_perso_skill?.should == true
    end
  end
  
  describe 'no_certif? method' do
    
    it { @candidate.should respond_to :no_certif? }
    
    it 'should be false for candidates with certificates' do
      @candidate.no_certif?.should == false
    end
    
    it 'should be true for candidates without certificate' do
      @certificate_candidate.destroy
      @candidate.no_certif?.should == true
    end
  end
  
  describe 'no_lang? method' do
    
    it { @candidate.should respond_to :no_lang? }
    
    it 'should be false for candidates with languages' do
      @candidate.no_lang?.should == false
    end
    
    it 'should be true for candidates without language' do
      @language_candidate.destroy
      @candidate.no_lang?.should == true
    end
  end
  
  describe 'no_social? method' do
    
    it { @candidate.should respond_to :no_social? }
    
    it 'should be false for candidates with all social networks' do
      @candidate.no_social?.should == false
    end
    
    it 'should be false for candidates with some social networks' do
      @candidate.update_attributes :facebook_login => ''
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
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  image              :string(255)
#  main_education     :integer(4)
#  main_experience    :integer(4)
#  quote              :string(255)
#  company_id         :integer(4)
#

