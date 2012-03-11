require 'spec_helper'

describe 'Candidates' do

  describe 'signup' do
    
    describe 'failure' do
      
      it 'should not sign a candidate up' do
        visit candidate_signup_path
        fill_in :candidate_email,                 :with => 'test@example.com'
        fill_in :candidate_password,              :with => 'password'
        fill_in :candidate_password_confirmation, :with => 'passwordd'
        click_button
        response.should render_template 'new'
      end
    end
    
    describe 'success' do
      
      it 'should sign a candidate up and set his profile completion to 5%' do
        visit candidate_signup_path
        fill_in :candidate_email,                 :with => 'test@example.com'
        fill_in :candidate_password,              :with => 'password'
        fill_in :candidate_password_confirmation, :with => 'password'
        click_button
        fill_in :candidate_first_name,            :with => 'Jack'
        fill_in :candidate_last_name,             :with => 'Bauer'
        fill_in :candidate_city,                  :with => 'Washington D.C.'
        fill_in :candidate_country,               :with => 'United States'
        click_button
        response.should render_template 'show'
        response.should have_selector 'div', :content => "#{I18n.t('candidates.show.profile_completion.sentence')}5#{I18n.t('candidates.show.profile_completion.%complete')}"
      end
    end
  end

  describe 'sign in/out' do
  
    describe 'failure' do
    
      it 'should not sign a candidate in' do
        visit signin_path
        fill_in :email,    :with => ''
        fill_in :password, :with => ''
        click_button
        response.should have_selector 'div.flash.error', :content => I18n.t('flash.error.signin')
      end
    end
  
    describe 'success' do
    
      before :each do
        @candidate = Factory :candidate
      end
      
      it 'should sign a candidate in' do
        visit signin_path
        fill_in :email,    :with => @candidate.email
        fill_in :password, :with => @candidate.password
        click_button
        controller.should be_signed_in
      end
      
      it 'should sign a candidate out' do
        visit signin_path
        fill_in :email,    :with => @candidate.email
        fill_in :password, :with => @candidate.password
        click_button
        click_link I18n.t(:sign_out)
        controller.should_not be_signed_in
      end
      
      it 'should redirect to the candidate profile page' do
        visit signin_path
        fill_in :email,    :with => @candidate.email
        fill_in :password, :with => @candidate.password
        click_button
        request.fullpath.should == candidate_path(@candidate)
      end      
    end
  end
  
  describe 'profile page' do
    
    before :each do
      @candidate = Factory :candidate
    end
    
    describe "standard and empty blocks display" do
      
      before :each do
        visit signin_path
        fill_in :email,    :with => @candidate.email
        fill_in :password, :with => @candidate.password
        click_button
      end
      
      it 'should display the top bar' do response.should have_selector 'div#show_top' end
      
      it "should display the candidate card" do response.should have_selector 'div', :class => 'card', :id => 'candidate_'+@candidate.id.to_s end
      
      it "should display the empty timeline block" do 
        response.should have_selector 'div#show_timeline'
        response.should have_selector 'div#timeline', :class => 'example'  
      end
        
      it "should display the empty professional_skills block" do 
        response.should have_selector 'div#professional_skill_candidates'
        response.should have_selector 'div.add_some', :content => I18n.t('professional_skills.add_some') 
      end
        
      it "should display the empty interpersonal_skills block" do 
        response.should have_selector 'div#interpersonal_skill_candidates'
        response.should have_selector 'div.add_some', :content => I18n.t('interpersonal_skills.add_some')
      end
        
      it "should display the empty experiences block" do 
        response.should have_selector 'div#experiences'
        response.should have_selector 'div.add_some', :content => I18n.t('experiences.add_some')
      end
        
      it "should display the empty educations block" do 
        response.should have_selector 'div#educations'
        response.should have_selector 'div.add_some', :content => I18n.t('educations.add_some') 
      end
        
      it "should display the empty certificates block" do 
        response.should have_selector 'div#certificate_candidates'
        response.should have_selector 'div.add_some', :content => I18n.t('certificates.add_some')
      end
      
      it "should display the empty languages block" do 
        response.should have_selector 'div#language_candidates'
        response.should have_selector 'div.add_some', :content => I18n.t('languages.add_some')
      end              
    end
    
    describe "block with attributes display" do

      it "should display the professional_skills block with the corresponding skill" do
        professional_skill = Factory :professional_skill        
        professional_skill_candidate = Factory :professional_skill_candidate, :candidate => @candidate, :professional_skill => professional_skill
        visit signin_path
        fill_in :email,    :with => @candidate.email
        fill_in :password, :with => @candidate.password
        click_button
        
        response.should have_selector 'div#professional_skill_candidates'
        response.should have_selector 'div', :id => 'professional_skill_candidate_'+professional_skill_candidate.id.to_s                                                                
      end
      
      it "should display the interpersonal_skills block with the corresponding skill" do
        interpersonal_skill = Factory :interpersonal_skill        
        interpersonal_skill_candidate = Factory :interpersonal_skill_candidate, :candidate => @candidate, :interpersonal_skill => interpersonal_skill
        visit signin_path
        fill_in :email,    :with => @candidate.email
        fill_in :password, :with => @candidate.password
        click_button
        
        response.should have_selector 'div#interpersonal_skill_candidates'
        response.should have_selector 'div', :id => 'interpersonal_skill_candidate_'+interpersonal_skill_candidate.id.to_s                                                                
      end
      
      it "should display the experiences block with the corresponding experience" do
        company = Factory :company        
        experience = Factory :experience, :candidate => @candidate, :company => company
        visit signin_path
        fill_in :email,    :with => @candidate.email
        fill_in :password, :with => @candidate.password
        click_button
        
        response.should have_selector 'div#experiences'
        response.should have_selector 'div', :id => 'experience_'+experience.id.to_s                                                                
      end
      
      it "should display the educations block with the corresponding education" do
        school = Factory :school
        degree_type = Factory :degree_type
        degree = Factory :degree, :degree_type => degree_type
        education = Factory :education, :candidate => @candidate, :school => school, :degree => degree
        visit signin_path
        fill_in :email,    :with => @candidate.email
        fill_in :password, :with => @candidate.password
        click_button
        
        response.should have_selector 'div#educations'
        response.should have_selector 'div', :id => 'education_'+education.id.to_s                                                                
      end
      
      it "should display the certificates block with the corresponding certificate" do
        certificate = Factory :certificate        
        certificate_candidate = Factory :certificate_candidate, :candidate => @candidate, :certificate => certificate
        visit signin_path
        fill_in :email,    :with => @candidate.email
        fill_in :password, :with => @candidate.password
        click_button
        
        response.should have_selector 'div#certificate_candidates'
        response.should have_selector 'div', :id => 'certificate_candidate_'+certificate_candidate.id.to_s                                                                
      end
      
      it "should display the languages block with the corresponding language" do
        language = Factory :language        
        language_candidate = Factory :language_candidate, :candidate => @candidate, :language => language
        visit signin_path
        fill_in :email,    :with => @candidate.email
        fill_in :password, :with => @candidate.password
        click_button
        
        response.should have_selector 'div#language_candidates'
        response.should have_selector 'div', :id => 'language_candidate_'+language_candidate.id.to_s                                                                
      end        
    end
    
    #describe "ajax creation", :js => true do
    #  
    #  describe "professional skills" do
    #    
    #    it "should display an empty form when we click on 'Add'" do
    #      
    #    end        
    #  end          
    #end
  end
end
