require 'spec_helper'

describe 'Authenticate' do
  
  before :each do
    @candidate = Factory :candidate
    @company   = Factory :company
    @recruiter = Factory :recruiter, :company => @company
  end
  
  after :each do
    current_path.should == signin_path
    find('div.flash.notice').should have_content I18n.t('flash.notice.please_signin')
  end
  
  describe 'Candidates' do
          
    it "should deny access to 'index' to non signed-in users" do
      visit candidates_path
      current_path.should_not == candidates_path
    end
      
    it "should deny access to 'show' to non signed-in users" do
      visit candidate_path(@candidate)
      current_path.should_not == candidate_path(@candidate)
    end
      
    it "should deny access to 'edit' to non signed-in users" do
      visit edit_candidate_path(@candidate)
      current_path.should_not == edit_candidate_path(@candidate)
    end
  end
  
  describe 'CertificateCandidates' do
    
    it "should deny access to 'new' to non signed-in users" do
      visit new_certificate_candidate_path
      current_path.should_not == new_certificate_candidate_path
    end
      
    it "should deny access to 'edit' to non signed-in users" do
      certificate_candidate = Factory :certificate_candidate, :candidate => @candidate
      visit edit_certificate_candidate_path(certificate_candidate)
      current_path.should_not == edit_certificate_candidate_path(certificate_candidate)
    end
  end
  
  describe 'Companies' do
          
    it "should deny access to 'show' to non signed-in users" do
      visit company_path(@company)
      current_path.should_not == company_path(@company)
    end
    
    it "should deny access to 'up_picture' to non signed-in users" do
      visit companies_up_picture_path
      current_path.should_not == companies_up_picture_path
    end
  end
  
  describe 'Educations' do
    
    it "should deny access to 'new' to non signed-in users"  do
      visit new_education_path
      current_path.should_not == new_education_path
    end
    
    it "should deny access to 'edit' to non signed-in users"  do
      education = Factory :education, :candidate => @candidate
      visit edit_education_path(education)
      current_path.should_not == edit_education_path(education)
    end
  end
  
  describe 'Experiences' do
    
    it "should deny access to 'new' to non signed-in users"  do
      visit new_experience_path
      current_path.should_not == new_experience_path
    end
    
    it "should deny access to 'edit' to non signed-in users"  do
      experience = Factory :experience, :candidate => @candidate
      visit edit_experience_path(experience)
      current_path.should_not == edit_experience_path(experience)
    end
  end
  
  describe 'InterpersonalSkillCandidates' do
    
    before :each do
      @interpersonal_skill_candidate = Factory :interpersonal_skill_candidate, :candidate => @candidate
    end
    
    it "should deny access to 'new' to non signed-in users"  do
      visit new_interpersonal_skill_candidate_path
      current_path.should_not == new_interpersonal_skill_candidate_path
    end
    
    it "should deny access to 'edit' to non signed-in users"  do
      visit edit_interpersonal_skill_candidate_path(@interpersonal_skill_candidate)
      current_path.should_not == edit_interpersonal_skill_candidate_path(@interpersonal_skill_candidate)
    end
  end
  
  describe 'LanguageCandidates' do
    
    before :each do
      @language_candidate = Factory :language_candidate, :candidate => @candidate
    end
    
    it "should deny access to 'new' to non signed-in users"  do
      visit new_language_candidate_path
      current_path.should_not == new_language_candidate_path
    end
    
    it "should deny access to 'edit' to non signed-in users"  do
      visit edit_language_candidate_path(@language_candidate)
      current_path.should_not == edit_language_candidate_path(@language_candidate)
    end
  end
  
  describe 'Messages' do
    
    before :each do
      @message = Factory :message, :author => @candidate, :recipient => @recruiter
    end
    
    it "should deny access to 'index' to non signed-in users" do
      visit messages_path
      current_path.should_not == messages_path
    end
    
    it "should deny access to 'show' to non signed-in users" do
      visit message_path(@message, :current_contact => @recruiter.id)
      current_path.should_not == message_path(@message, :current_contact => @recruiter.id)
    end
    
    it "should deny access to 'new' to non signed-in users" do
      visit new_message_path
      current_path.should_not == new_message_path
    end
    
    it "should deny access to 'menu_top' to non signed-in users" do
      visit messages_menu_top_path
      current_path.should_not == messages_menu_top_path
    end
    
    it "should deny access to 'menu_left' to non signed-in users" do
      visit messages_menu_left_path
      current_path.should_not == messages_menu_left_path
    end
    
    it "should deny access to 'archive' to non signed-in users" do
      visit messages_archive_path
      current_path.should_not == messages_archive_path
    end 
  end
  
  describe 'ProfessionalSkillCandidates' do
    
    before :each do
      @professional_skill_candidate = Factory :professional_skill_candidate, :candidate => @candidate
    end
    
    it "should deny HTML access to 'new'"  do
      visit new_professional_skill_candidate_path
      current_path.should_not == new_professional_skill_candidate_path
    end
    
    it "should deny HTML access to 'edit'"  do
      visit edit_professional_skill_candidate_path(@professional_skill_candidate)
      current_path.should_not == edit_professional_skill_candidate_path(@professional_skill_candidate)
    end
  end
  
  describe 'Recruiters' do

    it "should deny access to 'index' to non signed-in users" do
      visit recruiters_path
      current_path.should_not == recruiters_path
    end
      
    it "should deny access to 'show' to non signed-in users" do
      visit recruiter_path(@recruiter)
      current_path.should_not == recruiter_path(@recruiter)
    end
   
    it "should deny access to 'edit' to non signed-in users" do
      visit edit_recruiter_path(@recruiter)
      current_path.should_not == edit_recruiter_path(@recruiter)
    end
  end
end
