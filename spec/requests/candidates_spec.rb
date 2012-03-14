require 'spec_helper'

describe 'Candidates' do

  describe 'signup' do
    
    describe 'failure' do
      
      it 'should not sign a candidate up' do
        visit candidate_signup_path
        fill_in 'candidate_email',                 :with => 'test@example.com'
        fill_in 'candidate_password',              :with => 'password'
        fill_in 'candidate_password_confirmation', :with => 'passwordd'
        click_button "#{I18n.t('candidates.new.set_up_profile')}"
        current_path.should == candidates_path
      end
    end
    
    describe 'success' do
      
      it 'should sign a candidate up and display his profile page' do
        visit candidate_signup_path
        fill_in 'candidate_email',                 :with => 'test@example.com'
        fill_in 'candidate_password',              :with => 'password'
        fill_in 'candidate_password_confirmation', :with => 'password'
        click_button "#{I18n.t('candidates.new.set_up_profile')}"
        fill_in 'candidate_first_name',            :with => 'Jack'
        fill_in 'candidate_last_name',             :with => 'Bauer'
        fill_in 'candidate_city',                  :with => 'Washington D.C.'
        fill_in 'candidate_country',               :with => 'United States'
        click_button "#{I18n.t('candidates.show.view_profile')}"
        current_path.should == candidate_path(Candidate.find_by_email('test@example.com'))
        find('div#completion_container').should have_content "#{I18n.t('candidates.show.profile_completion.sentence')}5#{I18n.t('candidates.show.profile_completion.%complete')}"
      end
    end
  end

  describe 'sign in/out' do
  
    describe 'failure' do
    
      it 'should not sign a candidate in' do
        visit signin_path
        fill_in 'email',    :with => ''
        fill_in 'password', :with => ''
        click_button "#{I18n.t('sessions.new.signin')}"
        find('div.flash.error').should have_content I18n.t('flash.error.signin')
      end
    end
  
    describe 'success' do
    
      before :each do
        @candidate = Factory :candidate
        @candidate.update_attributes :profile_completion => 5
      end
      
      it 'should sign redirect to the root path during a signin' do
        visit signin_path
        fill_in 'email',    :with => @candidate.email
        fill_in 'password', :with => @candidate.password
        click_button "#{I18n.t('sessions.new.signin')}"
        click_link I18n.t(:sign_out)
        current_path.should == root_path
      end
      
      it 'should redirect to the candidate profile page after a signin' do
        visit signin_path
        fill_in 'email',    :with => @candidate.email
        fill_in 'password', :with => @candidate.password
        click_button "#{I18n.t('sessions.new.signin')}"
        current_path.should == candidate_path(@candidate)
      end      
    end
  end
  
  describe 'profile page' do
    
    before :each do
      @candidate = Factory :candidate
      @candidate.update_attributes :profile_completion => 5
    end
    
    describe "standard and empty blocks display" do
      
      before :each do
        visit signin_path
        fill_in 'email',    :with => @candidate.email
        fill_in 'password', :with => @candidate.password
        click_button "#{I18n.t('sessions.new.signin')}"
      end
      
      it 'should display the top bar' do page.should have_selector 'div#show_top' end
      
      it "should display the candidate card" do page.should have_selector 'div', :class => 'card', :id => 'candidate_'+@candidate.id.to_s end
      
      it "should display the empty timeline block" do 
        page.should have_css 'div#show_timeline'
        find('div#timeline').find('h1').should have_content(I18n.t('candidates.show.timeline.title').remove_accents.upcase)
      end
        
      it "should display the empty professional_skills block" do find('div#professional_skill_candidates').should have_content I18n.t('professional_skills.add_some') end
        
      it "should display the empty interpersonal_skills block" do find('div#interpersonal_skill_candidates').should have_content I18n.t('interpersonal_skills.add_some') end
        
      it "should display the empty experiences block" do find('div#experiences').should have_content I18n.t('experiences.add_some') end
        
      it "should display the empty educations block" do find('div#educations').should have_content I18n.t('educations.add_some') end
        
      it "should display the empty certificates block" do find('div#certificate_candidates').should have_content I18n.t('certificates.add_some') end
      
      it "should display the empty languages block" do find('div#language_candidates').should have_content I18n.t('languages.add_some') end              
    end
    
    describe "block with attributes display" do

      it "should display the professional_skills block with the corresponding skill" do
        professional_skill = Factory :professional_skill        
        professional_skill_candidate = Factory :professional_skill_candidate, :candidate => @candidate, :professional_skill => professional_skill
        visit signin_path
        fill_in 'email',    :with => @candidate.email
        fill_in 'password', :with => @candidate.password
        click_button "#{I18n.t('sessions.new.signin')}"
        
        page.should have_selector 'div#professional_skill_candidates'
        page.should have_selector 'div#professional_skill_candidate_'+professional_skill_candidate.id.to_s                                                                
      end
      
      it "should display the interpersonal_skills block with the corresponding skill" do
        interpersonal_skill = Factory :interpersonal_skill        
        interpersonal_skill_candidate = Factory :interpersonal_skill_candidate, :candidate => @candidate, :interpersonal_skill => interpersonal_skill
        visit signin_path
        fill_in 'email',    :with => @candidate.email
        fill_in 'password', :with => @candidate.password
        click_button "#{I18n.t('sessions.new.signin')}"
        
        page.should have_selector 'div#interpersonal_skill_candidates'
        page.should have_selector 'div#interpersonal_skill_candidate_'+interpersonal_skill_candidate.id.to_s                                                                
      end
      
      it "should display the experiences block with the corresponding experience" do
        company = Factory :company        
        experience = Factory :experience, :candidate => @candidate, :company => company
        visit signin_path
        fill_in 'email',    :with => @candidate.email
        fill_in 'password', :with => @candidate.password
        click_button "#{I18n.t('sessions.new.signin')}"
        
        page.should have_selector 'div#experiences'
        page.should have_selector 'div#experience_'+experience.id.to_s                                                                
      end
      
      it "should display the educations block with the corresponding education" do
        school = Factory :school
        degree_type = Factory :degree_type
        degree = Factory :degree, :degree_type => degree_type
        education = Factory :education, :candidate => @candidate, :school => school, :degree => degree
        visit signin_path
        fill_in 'email',    :with => @candidate.email
        fill_in 'password', :with => @candidate.password
        click_button "#{I18n.t('sessions.new.signin')}"
        
        page.should have_selector 'div#educations'
        page.should have_selector 'div#education_'+education.id.to_s                                                                
      end
      
      it "should display the certificates block with the corresponding certificate" do
        certificate = Factory :certificate        
        certificate_candidate = Factory :certificate_candidate, :candidate => @candidate, :certificate => certificate
        visit signin_path
        fill_in 'email',    :with => @candidate.email
        fill_in 'password', :with => @candidate.password
        click_button "#{I18n.t('sessions.new.signin')}"
        
        page.should have_selector 'div#certificate_candidates'
        page.should have_selector 'div#certificate_candidate_'+certificate_candidate.id.to_s                                                                
      end
      
      it "should display the languages block with the corresponding language" do
        language = Factory :language        
        language_candidate = Factory :language_candidate, :candidate => @candidate, :language => language
        visit signin_path
        fill_in 'email',    :with => @candidate.email
        fill_in 'password', :with => @candidate.password
        click_button "#{I18n.t('sessions.new.signin')}"
        
        page.should have_selector 'div#language_candidates'
        page.should have_selector 'div#language_candidate_'+language_candidate.id.to_s                                                             
      end        
    end
    
    describe "ajax creation" do
      
      before :each do
        require 'coffee_script'
        require 'less'
        @candidate = Factory :candidate
        @candidate.update_attributes :profile_completion => 5
        visit signin_path
        fill_in 'email',    :with => @candidate.email
        fill_in 'password', :with => @candidate.password
        click_button "#{I18n.t('sessions.new.signin')}"
      end
    
      describe 'professional skills' do
       
        it "should display an empty form when we click on 'Add'", :js => true do
          click_link 'link_add_professional_skill_candidate'
          page.should have_selector 'form#new_professional_skill_candidate'
          find('form#new_professional_skill_candidate').find('div.professional_skill_candidate')
        end
        
        it "should hide the form when we click on 'Cancel'", :js => true do
          click_link 'link_add_professional_skill_candidate'
          click_link "#{I18n.t('cancel')}"
          find('form#new_professional_skill_candidate').visible?.should be_false
        end
        
        it 'should display an error message when we submit an empty form', :js => true do
          click_link 'link_add_professional_skill_candidate'
          click_button "#{I18n.t('submit')}"
          find('form#new_professional_skill_candidate').visible?.should be_true
          find('div#errors_new_professional_skill_candidate').should have_content 'professional_skill.label'
        end        
      end  
=begin        
        describe 'item creation' do
          
          before :each do
            click_link 'link_add_professional_skill_candidate'
            fill_in 'professional_skill_candidate_professional_skill_attributes_label', :with => 'User Training'
            fill_in 'professional_skill_candidate_experience',                          :with => '1'
          end
          
          it "should create an object in the db", :js => true do
            lambda do              
              click_button "#{I18n.t('submit')}"              
            end.should change(CertificateCandidate, :count).by(1)
          end
          
          it "should hide the form", :js => true do
            click_button "#{I18n.t('submit')}"
            find('form#new_professional_skill_candidate').visible?.should be_false
          end
          
          it "should display the block with the created object", :js => true do
            click_button "#{I18n.t('submit')}"
            professional_skill_candidate = assigns :professional_skill_candidate
            page.should have_selector "div#professional_skill_candidate_#{professional_skill_candidate.id}"
          end   
        end        
      end
=end      
      describe 'interpersonal skills' do
        
        it "should display an empty form when we click on 'Add'", :js => true do
          click_link 'link_add_interpersonal_skill_candidate'
          page.should have_selector 'form#new_interpersonal_skill_candidate'
          find('form#new_interpersonal_skill_candidate').find('div#errors_new_interpersonal_skill_candidate')
        end
        
        it "should hide the form when we click on 'Cancel'", :js => true do
          click_link 'link_add_interpersonal_skill_candidate'
          click_link "#{I18n.t('cancel')}"
          find('form#new_interpersonal_skill_candidate').visible?.should be_false
        end
        
        it 'should display an error message when we submit an empty form', :js => true do
          click_link 'link_add_interpersonal_skill_candidate'
          click_button "#{I18n.t('submit')}"
          find('form#new_interpersonal_skill_candidate').visible?.should be_true
          find('div#errors_new_interpersonal_skill_candidate').should have_content 'interpersonal_skill.label'
        end 
      end
      
      describe 'experiences' do
        
        it "should display an empty form when we click on 'Add'", :js => true do
          click_link 'link_add_experience'
          page.should have_selector 'form#new_experience'
          find('form#new_experience').find('div.edu_exp_date')
        end
        
        it "should hide the form when we click on 'Cancel'", :js => true do
          click_link 'link_add_experience'
          click_link "#{I18n.t('cancel')}"
          find('form#new_experience').visible?.should be_false
        end
        
        it 'should display an error message when we submit an empty form', :js => true do
          click_link 'link_add_experience'
          click_button "#{I18n.t('submit')}"
          find('form#new_experience').visible?.should be_true
          find('div#errors_new_experience').should have_content 'company.name'
          find('div#errors_new_experience').should have_content 'role'
          find('div#errors_new_experience').should have_content 'start_month'
          find('div#errors_new_experience').should have_content 'start_year'
          find('div#errors_new_experience').should have_content 'end_month'
          find('div#errors_new_experience').should have_content 'end_year'          
        end
      end
      
      describe 'educations' do
        
        it "should display an empty form when we click on 'Add'", :js => true do
          click_link 'link_add_education'
          page.should have_selector 'form#new_education'
          find('form#new_education').find('div.edu_exp_date')
        end
         
        it "should hide the form when we click on 'Cancel'", :js => true do
          click_link 'link_add_education'
          click_link "#{I18n.t('cancel')}"
          find('form#new_education').visible?.should be_false
        end
        
        it 'should display an error message when we submit an empty form', :js => true do
          click_link 'link_add_education'
          click_button "#{I18n.t('submit')}"
          find('form#new_education').visible?.should be_true
          find('div#errors_new_education').should have_content 'school.name'
          find('div#errors_new_education').should have_content 'degree.degree_type.label'
          find('div#errors_new_education').should have_content 'degree.label'
          find('div#errors_new_education').should have_content 'start_month'
          find('div#errors_new_education').should have_content 'start_year'
          find('div#errors_new_education').should have_content 'end_month'
          find('div#errors_new_education').should have_content 'end_year'          
        end
      end
      
      describe 'certificates' do
        
        it "should display an empty form when we click on 'Add'", :js => true do
          click_link 'link_add_certificate_candidate'
          page.should have_selector 'form#new_certificate_candidate'
          find('form#new_certificate_candidate').find('div.certificate_candidate')
        end
        
        it "should hide the form when we click on 'Cancel'", :js => true do
          click_link 'link_add_certificate_candidate'
          click_link "#{I18n.t('cancel')}"
          find('form#new_certificate_candidate').visible?.should be_false
        end

        it 'should display an error message when we submit an empty form', :js => true do
          click_link 'link_add_certificate_candidate'
          click_button "#{I18n.t('submit')}"
          find('form#new_certificate_candidate').visible?.should be_true
          find('div#errors_new_certificate_candidate').should have_content 'certificate.label'
        end
      end

      describe 'languages' do
        
        it "should display an empty form when we click on 'Add'", :js => true do
          click_link 'link_add_language_candidate'
          page.should have_selector 'form#new_language_candidate'
          find('form#new_language_candidate').find('div.language_candidate')
        end
        
        it "should hide the form when we click on 'Cancel'", :js => true do
          click_link 'link_add_language_candidate'
          click_link "#{I18n.t('cancel')}"
          find('form#new_language_candidate').visible?.should be_false
        end
        
        it 'should display an error message when we submit an empty form', :js => true do
          click_link 'link_add_language_candidate'
          click_button "#{I18n.t('submit')}"
          find('form#new_language_candidate').visible?.should be_true
          find('div#errors_new_language_candidate').should have_content 'language.label'
        end 
      end                   
    end
  end
end
