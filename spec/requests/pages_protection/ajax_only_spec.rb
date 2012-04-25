require 'spec_helper'

describe 'AjaxOnly' do
  
  before :each do
    @candidate = Factory :candidate, :profile_completion => 5
    @recruiter = Factory :recruiter, :profile_completion => 5
    visit signin_path
    fill_in 'email',    :with => @candidate.email
    fill_in 'password', :with => @candidate.password
    click_button I18n.t('sessions.new.signin')
  end
  
  after :each do
    current_path.should == candidate_path(@candidate)
    find('div.flash.notice').should have_content I18n.t('flash.notice.restricted_page')
  end
  
  describe 'CertificateCandidates' do
    
    before :each do
      @certificate_candidate = Factory :certificate_candidate, :candidate => @candidate
    end
    
    it "should deny HTML access to 'new'"  do
      visit new_certificate_candidate_path
      current_path.should_not == new_certificate_candidate_path
    end
    
    it "should deny HTML access to 'edit'"  do
      visit edit_certificate_candidate_path(@certificate_candidate)
      current_path.should_not == edit_certificate_candidate_path(@certificate_candidate)
    end
  end
  
  describe 'Educations' do
    
    before :each do
      @education = Factory :education, :candidate => @candidate
    end
    
    it "should deny HTML access to 'edit'"  do
      visit edit_education_path(@education)
      current_path.should_not == edit_education_path(@education)
    end
  end
  
  describe 'Experiences' do
    
    before :each do
      @experience = Factory :experience, :candidate => @candidate
    end
    
    it "should deny HTML access to 'edit'"  do
      visit edit_experience_path(@experience)
      current_path.should_not == edit_experience_path(@experience)
    end
  end
  
  describe 'InterpersonalSkillCandidates' do
    
    before :each do
      @interpersonal_skill_candidate = Factory :interpersonal_skill_candidate, :candidate => @candidate
    end
    
    it "should deny HTML access to 'new'"  do
      visit new_interpersonal_skill_candidate_path
      current_path.should_not == new_interpersonal_skill_candidate_path
    end
    
    it "should deny HTML access to 'edit'"  do
      visit edit_interpersonal_skill_candidate_path(@interpersonal_skill_candidate)
      current_path.should_not == edit_interpersonal_skill_candidate_path(@interpersonal_skill_candidate)
    end
  end
  
  describe 'LanguageCandidates' do
    
    before :each do
      @language_candidate = Factory :language_candidate, :candidate => @candidate
    end
    
    it "should deny HTML access to 'new'"  do
      visit new_language_candidate_path
      current_path.should_not == new_language_candidate_path
    end
    
    it "should deny HTML access to 'edit'"  do
      visit edit_language_candidate_path(@language_candidate)
      current_path.should_not == edit_language_candidate_path(@language_candidate)
    end
  end
  
  describe 'Messages' do
    
    before :each do
      @message = Factory :message, :author => @candidate, :recipient => @recruiter
    end
    
    it "should deny HTML access to 'new'"  do
      visit new_message_path
      current_path.should_not == new_message_path
    end
    
    it "should deny HTML access to 'show'"  do
      visit message_path(@message, :current_contact => @recruiter.id)
      current_path.should_not == message_path(@message, :current_contact => @recruiter.id)
    end
    
    it "should deny HTML access to 'menu_top'"  do
      visit messages_menu_top_path
      current_path.should_not == messages_menu_top_path
    end
    
    it "should deny HTML access to 'menu_left'"  do
      visit messages_menu_left_path
      current_path.should_not == messages_menu_left_path
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
end