require 'spec_helper'

describe 'Candidates' do

  describe 'signup' do
    
    before :each do
      visit candidate_signup_path
      fill_in 'candidate_email',                 :with => 'test@example.com'
      fill_in 'candidate_password',              :with => 'password'    
    end
    
    describe 'failure' do
      
      it 'should not sign a candidate up' do
        fill_in 'candidate_password_confirmation', :with => 'passwordd'
        click_button "#{I18n.t('candidates.new.set_up_profile')}"
        current_path.should == candidates_path
      end
    end
    
    describe 'success' do
      
      it 'should sign a candidate up and display his profile page' do
        fill_in 'candidate_password_confirmation', :with => 'password'
        click_button "#{I18n.t('candidates.new.set_up_profile')}"
        fill_in 'candidate_first_name',            :with => 'Jack'
        fill_in 'candidate_last_name',             :with => 'Bauer'
        fill_in 'candidate_city',                  :with => 'Washington D.C.'
        fill_in 'candidate_country',               :with => 'United States'
        click_button "#{I18n.t('candidates.show.view_profile')}"
        current_path.should == candidate_path(Candidate.find_by_email('test@example.com'))
        find('div#completion_container').should have_content "#{I18n.t('candidates.show.profile_completion.sentence')}\n5\n#{I18n.t('candidates.show.profile_completion.%complete')}"
      end
    end
  end

  describe 'signin / signout' do
  
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
        visit signin_path
        fill_in 'email',    :with => @candidate.email
        fill_in 'password', :with => @candidate.password
        click_button "#{I18n.t('sessions.new.signin')}"
      end
      
      it 'should sign a candidate in' do
        current_path.should == recruiters_path
      end 
      
       it 'should sign a candidate out' do
          click_link I18n.t(:sign_out)
          current_path.should == root_path
        end     
    end
  end
  
  describe 'profile' do
    
    before :each do
      @candidate = Factory :candidate
      @candidate.update_attributes :profile_completion => 5
    end
    
    describe 'when empty' do
      
      before :each do
        visit signin_path
        fill_in 'email',    :with => @candidate.email
        fill_in 'password', :with => @candidate.password
        click_button "#{I18n.t('sessions.new.signin')}"
        visit candidate_path @candidate
      end
      
      it 'should have a top bar' do
        page.should have_selector 'div#completion_container'
      end
      
      it 'should have a candidate card' do
        page.should have_selector 'div.card'
      end
      
      it 'should have an empty timeline' do 
        page.should have_css 'div#show_timeline'
        find('div#timeline').find('h1').should have_content(I18n.t('candidates.show.timeline.title').remove_accents.upcase)
      end
        
      it 'should have an empty professional_skills block' do
        find('div#professional_skill_candidates').should have_content I18n.t('professional_skills.add_some')
      end
        
      it 'should have an empty interpersonal_skills block' do
        find('div#interpersonal_skill_candidates').should have_content I18n.t('interpersonal_skills.add_some')
      end
        
      it 'should have an empty experiences block' do
        find('div#experiences').should have_content I18n.t('experiences.add_some')
      end
        
      it 'should have an empty educations block' do
        find('div#educations').should have_content I18n.t('educations.add_some')
      end
        
      it 'should have an empty certificates block' do
        find('div#certificate_candidates').should have_content I18n.t('certificates.add_some')
      end
      
      it 'should have an empty languages block' do
        find('div#language_candidates').should have_content I18n.t('languages.add_some')
      end              
    end
    
    describe 'when complete' do

      it 'should have a professional_skills block with a skill' do
        professional_skill = Factory :professional_skill        
        professional_skill_candidate = Factory :professional_skill_candidate, :candidate => @candidate, :professional_skill => professional_skill
        visit signin_path
        fill_in 'email',    :with => @candidate.email
        fill_in 'password', :with => @candidate.password
        click_button "#{I18n.t('sessions.new.signin')}"
        visit candidate_path @candidate
        page.should have_selector 'div#professional_skill_candidates'
        page.should have_selector "div#professional_skill_candidate_#{professional_skill_candidate.id}"                                                                
      end
      
      it 'should have an interpersonal_skills block with a skill' do
        interpersonal_skill = Factory :interpersonal_skill        
        interpersonal_skill_candidate = Factory :interpersonal_skill_candidate, :candidate => @candidate, :interpersonal_skill => interpersonal_skill
        visit signin_path
        fill_in 'email',    :with => @candidate.email
        fill_in 'password', :with => @candidate.password
        click_button "#{I18n.t('sessions.new.signin')}"
        visit candidate_path @candidate
        page.should have_selector 'div#interpersonal_skill_candidates'
        page.should have_selector "div#interpersonal_skill_candidate_#{interpersonal_skill_candidate.id}"
      end
      
      it 'should have an experiences block with an experience' do
        company = Factory :company        
        experience = Factory :experience, :candidate => @candidate, :company => company
        visit signin_path
        fill_in 'email',    :with => @candidate.email
        fill_in 'password', :with => @candidate.password
        click_button "#{I18n.t('sessions.new.signin')}"
        visit candidate_path @candidate
        page.should have_selector 'div#experiences'
        page.should have_selector "div#experience_#{experience.id}"
      end
      
      it 'should have an educations block with an education' do
        school = Factory :school
        degree_type = Factory :degree_type
        degree = Factory :degree, :degree_type => degree_type
        education = Factory :education, :candidate => @candidate, :school => school, :degree => degree
        visit signin_path
        fill_in 'email',    :with => @candidate.email
        fill_in 'password', :with => @candidate.password
        click_button "#{I18n.t('sessions.new.signin')}"
        visit candidate_path @candidate
        page.should have_selector 'div#educations'
        page.should have_selector "div#education_#{education.id}"                                                            
      end
      
      it 'should have a certificates block with a certificate' do
        certificate = Factory :certificate        
        certificate_candidate = Factory :certificate_candidate, :candidate => @candidate, :certificate => certificate
        visit signin_path
        fill_in 'email',    :with => @candidate.email
        fill_in 'password', :with => @candidate.password
        click_button "#{I18n.t('sessions.new.signin')}"
        visit candidate_path @candidate
        page.should have_selector 'div#certificate_candidates'
        page.should have_selector "div#certificate_candidate_#{certificate_candidate.id}"                                                                
      end
      
      it 'should have a languages block with a language' do
        language = Factory :language        
        language_candidate = Factory :language_candidate, :candidate => @candidate, :language => language
        visit signin_path
        fill_in 'email',    :with => @candidate.email
        fill_in 'password', :with => @candidate.password
        click_button "#{I18n.t('sessions.new.signin')}"
        visit candidate_path @candidate
        page.should have_selector 'div#language_candidates'
        page.should have_selector "div#language_candidate_#{language_candidate.id}"
      end        
    end

    describe 'ajax', :js => true do
      
      before :each do
        require 'coffee_script'
        require 'less'
        @candidate = Factory :candidate
        @candidate.update_attributes :profile_completion => 5
      end
    
      describe 'professional skills' do
       
        before :each do
          @professional_skill_candidate = Factory :professional_skill_candidate, :candidate => @candidate
          visit signin_path
          fill_in 'email',    :with => @candidate.email
          fill_in 'password', :with => @candidate.password
          click_button "#{I18n.t('sessions.new.signin')}"
          visit candidate_path @candidate
        end
       
        it "should have an empty form after 'ADD +' is clicked" do
          click_link 'link_add_professional_skill_candidate'
          page.should have_selector 'form#new_professional_skill_candidate'
          find('form#new_professional_skill_candidate').find('div.professional_skill_candidate')
        end
        
        it "should have a hidden form after 'Cancel' is clicked" do
          click_link 'link_add_professional_skill_candidate'
          click_link "#{I18n.t('cancel')}"
          find('form#new_professional_skill_candidate').visible?.should be_false
        end
        
        it 'should have an error message when an empty form is submitted' do
          click_link 'link_add_professional_skill_candidate'
          click_button "#{I18n.t('submit')}"
          find('form#new_professional_skill_candidate').visible?.should be_true
          find('div#errors_new_professional_skill_candidate').should have_content 'professional_skill.label'
        end
        
        it 'should have a hidden show block and a visible edit block when clicked' do
          find("div#show_professional_skill_candidate_#{@professional_skill_candidate.id}").click
          find("div#edit_professional_skill_candidate_#{@professional_skill_candidate.id}").visible?.should be_true
          find("div#show_professional_skill_candidate_#{@professional_skill_candidate.id}").visible?.should be_false
        end  
    
        describe 'create' do
          
          before :each do
            click_link 'link_add_professional_skill_candidate'
            fill_in 'professional_skill_candidate_professional_skill_attributes_label', :with => 'User Training'
            fill_in 'professional_skill_candidate_experience',                          :with => '1'
            page.select(I18n.t('skills.beginner'), :from => 'professional_skill_candidate_level')
            click_button "#{I18n.t('submit')}"
          end
          
          it 'should create a new object' do
            lambda do 
              sleep(2)  
            end.should change(ProfessionalSkillCandidate, :count).by(1)
          end
          
          it "shouldn't have a new form anymore" do
            page.should_not have_selector 'form#new_professional_skill_candidate'
          end                       
        end
        
        describe 'update' do
          
          before :each do
            find("div#show_professional_skill_candidate_#{@professional_skill_candidate.id}").click
          end
          
          it 'should have an error message when a field is deleted' do
            fill_in 'professional_skill_candidate_professional_skill_attributes_label', :with => ''
            click_button "#{I18n.t('submit')}"
            find("div#edit_professional_skill_candidate_#{@professional_skill_candidate.id}").visible?.should be_true
            find("div.error_messages").should have_content 'professional_skill.label'
          end
          
          it 'should have the updated details and a hidden edit form when correct data is submitted' do
            fill_in 'professional_skill_candidate_professional_skill_attributes_label', :with => 'Web Development'
            click_button "#{I18n.t('submit')}"
            sleep(2)
            find("div#edit_professional_skill_candidate_#{@professional_skill_candidate.id}").visible?.should be_false
            find("div#show_professional_skill_candidate_#{@professional_skill_candidate.id}").should have_content 'Web Development'
          end
        end
        
        describe 'destroy' do
          
          before :each do
            find("div#show_professional_skill_candidate_#{@professional_skill_candidate.id}").click
            click_link "#{I18n.t('delete')}"
          end
          
          it 'should destroy the object' do
            lambda do
              sleep(2)
            end.should change(ProfessionalSkillCandidate,:count).by(-1)
          end
          
          it "shouldn't have an edit form anymore" do
            page.should_not have_selector "div#edit_professional_skill_candidate_#{@professional_skill_candidate.id}"
          end

          it "shouldn't have a show block anymore" do
            page.should_not have_selector "div#show_professional_skill_candidate_#{@professional_skill_candidate.id}"
          end
          
          it 'should have an empty block' do
            find('div#professional_skill_candidates').should have_content I18n.t('professional_skills.add_some')
          end
          
          it "should have a new form when an object was just destroyed and 'ADD +' is clicked" do
            sleep(2)
            click_link 'link_add_professional_skill_candidate'
            page.should have_selector 'form#new_professional_skill_candidate'
            find('form#new_professional_skill_candidate').find('div.professional_skill_candidate')
          end
        end       
      end
      
      describe 'interpersonal skills' do
        
        before :each do
          @interpersonal_skill_candidate = Factory :interpersonal_skill_candidate, :candidate => @candidate
          visit signin_path
          fill_in 'email',    :with => @candidate.email
          fill_in 'password', :with => @candidate.password
          click_button "#{I18n.t('sessions.new.signin')}"
          visit candidate_path @candidate
        end
        
        it "should have an empty form after 'ADD +' is clicked" do
          click_link 'link_add_interpersonal_skill_candidate'
          page.should have_selector 'form#new_interpersonal_skill_candidate'
          find('form#new_interpersonal_skill_candidate').find('div#errors_new_interpersonal_skill_candidate')
        end
        
        it "should have a hidden form after 'Cancel' is clicked" do
          click_link 'link_add_interpersonal_skill_candidate'
          click_link "#{I18n.t('cancel')}"
          find('form#new_interpersonal_skill_candidate').visible?.should be_false
        end
        
        it 'should have an error message when an empty form is submitted' do
          click_link 'link_add_interpersonal_skill_candidate'
          click_button "#{I18n.t('submit')}"
          find('form#new_interpersonal_skill_candidate').visible?.should be_true
          find('div#errors_new_interpersonal_skill_candidate').should have_content 'interpersonal_skill.label'
        end
        
        it 'should have a hidden show block and a visible edit block when clicked' do
          find("div#show_interpersonal_skill_candidate_#{@interpersonal_skill_candidate.id}").click
          find("div#edit_interpersonal_skill_candidate_#{@interpersonal_skill_candidate.id}").visible?.should be_true
          find("div#show_interpersonal_skill_candidate_#{@interpersonal_skill_candidate.id}").visible?.should be_false
        end  
    
        describe 'create' do
          
          before :each do
            click_link 'link_add_interpersonal_skill_candidate'
            fill_in 'interpersonal_skill_candidate_interpersonal_skill_attributes_label', :with => 'Patience'
            click_button "#{I18n.t('submit')}"             
          end
          
          it 'should create a new object' do
            lambda do              
              sleep(2)          
            end.should change(InterpersonalSkillCandidate, :count).by(1)
          end
          
          it "shouldn't have a new form anymore" do
            page.should_not have_selector 'form#new_interpersonal_skill_candidate'
          end                       
        end

        describe 'update' do
          
          before :each do
            find("div#show_interpersonal_skill_candidate_#{@interpersonal_skill_candidate.id}").click
          end
          
          it 'should have an error message when a field is deleted' do
            fill_in 'interpersonal_skill_candidate_interpersonal_skill_attributes_label', :with => ''
            click_button "#{I18n.t('submit')}"
            find("div#edit_interpersonal_skill_candidate_#{@interpersonal_skill_candidate.id}").visible?.should be_true
            find("div.error_messages").should have_content 'interpersonal_skill.label'
          end
          
          it 'should have the updated details and a hidden edit form when correct data is submitted' do
            fill_in 'interpersonal_skill_candidate_interpersonal_skill_attributes_label', :with => 'Self Confidence'
            click_button "#{I18n.t('submit')}"
            sleep(2)
            find("div#edit_interpersonal_skill_candidate_#{@interpersonal_skill_candidate.id}").visible?.should be_false
            find("div#show_interpersonal_skill_candidate_#{@interpersonal_skill_candidate.id}").should have_content 'Self Confidence'
          end
        end
        
        describe 'destroy' do
          
          before :each do
            find("div#show_interpersonal_skill_candidate_#{@interpersonal_skill_candidate.id}").click
            click_link "#{I18n.t('delete')}"
          end
          
          it 'should destroy the object' do
            lambda do
              sleep(2)
            end.should change(InterpersonalSkillCandidate,:count).by(-1)
          end
          
          it "shouldn't have an edit form anymore" do
            page.should_not have_selector "div#edit_interpersonal_skill_candidate_#{@interpersonal_skill_candidate.id}"
          end

          it "shouldn't have a show block anymore" do
            page.should_not have_selector "div#show_interpersonal_skill_candidate_#{@interpersonal_skill_candidate.id}"
          end
          
          it 'should have an empty block' do
            find('div#interpersonal_skill_candidates').should have_content I18n.t('interpersonal_skills.add_some')
          end
          
          it "should have a new form when an object was just destroyed and 'ADD +' is clicked" do
            sleep(2)
            click_link 'link_add_interpersonal_skill_candidate'
            page.should have_selector 'form#new_interpersonal_skill_candidate'
            find('form#new_interpersonal_skill_candidate').find('div#errors_new_interpersonal_skill_candidate')
          end
        end
      end
      
      describe 'experiences' do

        before :each do
          @experience = Factory :experience, :candidate => @candidate
          visit signin_path
          fill_in 'email',    :with => @candidate.email
          fill_in 'password', :with => @candidate.password
          click_button "#{I18n.t('sessions.new.signin')}"
          visit candidate_path @candidate
        end
                
        it "should have an empty form after 'ADD +' is clicked" do
          click_link 'link_add_experience'
          page.should have_selector 'form#new_experience'
          find('form#new_experience').find('div.edu_exp_date')
        end
        
        it "should have a hidden form after 'Cancel' is clicked" do
          click_link 'link_add_experience'
          click_link "#{I18n.t('cancel')}"
          find('form#new_experience').visible?.should be_false
        end
        
        it 'should have an error message when an empty form is submitted' do
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
        
        it 'should have a hidden show block and a visible edit block when clicked' do
          find("div#show_experience_#{@experience.id}").click
          find("div#edit_experience_#{@experience.id}").visible?.should be_true
          find("div#show_experience_#{@experience.id}").visible?.should be_false
        end
        
        describe 'create' do
          
          before :each do
            click_link 'link_add_experience'
            fill_in 'experience_company_attributes_name', :with => 'Logicaaaa'
            fill_in 'experience_role',                    :with => 'IT Trainee'
            fill_in 'experience_start_month',             :with => '1'
            fill_in 'experience_start_year',              :with => '2000'
            fill_in 'experience_end_month',               :with => '5'
            fill_in 'experience_end_year',                :with => '2000'
            click_button "#{I18n.t('submit')}"             
          end
          
          it 'should create a new object' do
            lambda do              
              sleep(2)          
            end.should change(Experience, :count).by(1)
          end
          
          it "shouldn't have a new form anymore" do
            page.should_not have_selector 'form#new_experience'
          end                       
        end

        describe 'update' do
          
          before :each do
            find("div#show_experience_#{@experience.id}").click
          end
          
          it 'should have an error message when a field is deleted' do
            fill_in 'experience_company_attributes_name', :with => ''
            click_button "#{I18n.t('submit')}"
            find("div#edit_experience_#{@experience.id}").visible?.should be_true
            find("div.error_messages").should have_content 'company.name'
          end
          
          it 'should have the updated details and a hidden edit form when correct data is submitted' do
            fill_in 'experience_company_attributes_name', :with => 'PXTherapeutics'
            click_button "#{I18n.t('submit')}"
            sleep(2)
            find("div#edit_experience_#{@experience.id}").visible?.should be_false
            find("div#show_experience_#{@experience.id}").should have_content 'PXTherapeutics'
          end
        end
        
        describe 'destroy' do
          
          before :each do
            find("div#show_experience_#{@experience.id}").click
            click_link "#{I18n.t('delete')}"
          end
          
          it 'should destroy the object' do
            lambda do
              sleep(2)
            end.should change(Experience,:count).by(-1)
          end
          
          it "shouldn't have an edit form anymore" do
            page.should_not have_selector "div#edit_experience_#{@experience.id}"
          end

          it "shouldn't have a show block anymore" do
            page.should_not have_selector "div#show_experience_#{@experience.id}"
          end
          
          it 'should have an empty block' do
            find('div#experiences').should have_content I18n.t('experiences.add_some')
          end
          
          it "should have a new form when an object was just destroyed and 'ADD +' is clicked" do
            sleep(2)
            click_link 'link_add_experience'
            page.should have_selector 'form#new_experience'
            find('form#new_experience').find('div.edu_exp_date')
          end
        end        
      end
      
      describe 'educations' do

        before :each do
          @education = Factory :education, :candidate => @candidate
          visit signin_path
          fill_in 'email',    :with => @candidate.email
          fill_in 'password', :with => @candidate.password
          click_button "#{I18n.t('sessions.new.signin')}"
          visit candidate_path @candidate
        end
        
        it "should have an empty form after 'ADD +' is clicked" do
          click_link 'link_add_education'
          page.should have_selector 'form#new_education'
          find('form#new_education').find('div.edu_exp_date')
        end
         
        it "should have a hidden form after 'Cancel' is clicked" do
          click_link 'link_add_education'
          click_link "#{I18n.t('cancel')}"
          find('form#new_education').visible?.should be_false
        end
        
        it 'should have an error message when an empty form is submitted' do
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

        it 'should have a hidden show block and a visible edit block when clicked' do
          find("div#show_education_#{@education.id}").click
          find("div#edit_education_#{@education.id}").visible?.should be_true
          find("div#show_education_#{@education.id}").visible?.should be_false
        end
                
        describe 'create' do
          
          before :each do
            click_link 'link_add_education'
            fill_in 'education_school_attributes_name',                         :with => 'UPMF Grenoble'
            fill_in 'education_degree_attributes_degree_type_attributes_label', :with => 'IUT'
            fill_in 'education_degree_attributes_label',                        :with => 'Tech de Co.'
            fill_in 'education_start_month',                                    :with => '9'
            fill_in 'education_start_year',                                     :with => '1998'
            fill_in 'education_end_month',                                      :with => '6'
            fill_in 'education_end_year',                                       :with => '1999'
            click_button "#{I18n.t('submit')}"             
          end
          
          it 'should create a new object' do
            lambda do              
              sleep(2)          
            end.should change(Education, :count).by(1)
          end
          
          it "shouldn't have a new form anymore" do
            page.should_not have_selector 'form#new_education'
          end                       
        end

        describe 'update' do
          
          before :each do
            find("div#show_education_#{@education.id}").click
          end
          
          it 'should have an error message when a field is deleted' do
            fill_in 'education_school_attributes_name', :with => ''
            click_button "#{I18n.t('submit')}"
            find("div#edit_education_#{@education.id}").visible?.should be_true
            find("div.error_messages").should have_content 'school.name'
          end
          
          it 'should have the updated details and a hidden edit form when correct data is submitted' do
            fill_in 'education_school_attributes_name', :with => 'UJF Grenoble'
            click_button "#{I18n.t('submit')}"
            sleep(2)
            find("div#edit_education_#{@education.id}").visible?.should be_false
            find("div#show_education_#{@education.id}").should have_content 'UJF Grenoble'
          end
        end
              
        describe 'destroy' do
          
          before :each do
            find("div#show_education_#{@education.id}").click
            click_link "#{I18n.t('delete')}"
          end
          
          it 'should destroy the object' do
            lambda do
              sleep(2)
            end.should change(Education,:count).by(-1)
          end
          
          it "shouldn't have an edit form anymore" do
            page.should_not have_selector "div#edit_education_#{@education.id}"
          end

          it "shouldn't have a show block anymore" do
            page.should_not have_selector "div#show_education_#{@education.id}"
          end
          
          it 'should have an empty block' do
            find('div#educations').should have_content I18n.t('educations.add_some')
          end
          
          it "should have a new form when an object was just destroyed and 'ADD +' is clicked" do
            sleep(2)
            click_link 'link_add_education'
            page.should have_selector 'form#new_education'
            find('form#new_education').find('div.edu_exp_date')
          end
        end
      end
      
      describe 'certificates' do

        before :each do
          @certificate_candidate = Factory :certificate_candidate, :candidate => @candidate
          visit signin_path
          fill_in 'email',    :with => @candidate.email
          fill_in 'password', :with => @candidate.password
          click_button "#{I18n.t('sessions.new.signin')}"
          visit candidate_path @candidate
        end
        
        it "should have an empty form after 'ADD +' is clicked" do
          click_link 'link_add_certificate_candidate'
          page.should have_selector 'form#new_certificate_candidate'
          find('form#new_certificate_candidate').find('div.certificate_candidate')
        end
        
        it "should have a hidden form after 'Cancel' is clicked" do
          click_link 'link_add_certificate_candidate'
          click_link "#{I18n.t('cancel')}"
          find('form#new_certificate_candidate').visible?.should be_false
        end

        it 'should have an error message when an empty form is submitted' do
          click_link 'link_add_certificate_candidate'
          click_button "#{I18n.t('submit')}"
          find('form#new_certificate_candidate').visible?.should be_true
          find('div#errors_new_certificate_candidate').should have_content 'certificate.label'
        end

        it 'should have a hidden show block and a visible edit block when clicked' do
          find("div#show_certificate_candidate_#{@certificate_candidate.id}").click
          find("div#edit_certificate_candidate_#{@certificate_candidate.id}").visible?.should be_true
          find("div#show_certificate_candidate_#{@certificate_candidate.id}").visible?.should be_false
        end
                
        describe 'create' do
          
          before :each do
            click_link 'link_add_certificate_candidate'
            fill_in 'certificate_candidate_certificate_attributes_label', :with => 'TOEFL'
            click_button "#{I18n.t('submit')}"             
          end
          
          it 'should create a new object' do
            lambda do              
              sleep(2)          
            end.should change(CertificateCandidate, :count).by(1)
          end
          
          it "shouldn't have a new form anymore" do
            page.should_not have_selector 'form#new_certificate_candidate'
          end                       
        end

        describe 'update' do
          
          before :each do
            find("div#show_certificate_candidate_#{@certificate_candidate.id}").click
          end
          
          it 'should have an error message when a field is deleted' do
            fill_in 'certificate_candidate_certificate_attributes_label', :with => ''
            click_button "#{I18n.t('submit')}"
            find("div#edit_certificate_candidate_#{@certificate_candidate.id}").visible?.should be_true
            find("div.error_messages").should have_content 'certificate.label'
          end
          
          it 'should have the updated details and a hidden edit form when correct data is submitted' do
            fill_in 'certificate_candidate_certificate_attributes_label', :with => 'Microsoft Certification'
            click_button "#{I18n.t('submit')}"
            sleep(2)
            find("div#edit_certificate_candidate_#{@certificate_candidate.id}").visible?.should be_false
            find("div#show_certificate_candidate_#{@certificate_candidate.id}").should have_content 'Microsoft Certification'
          end
        end

        describe 'destroy' do
          
          before :each do
            find("div#show_certificate_candidate_#{@certificate_candidate.id}").click
            click_link "#{I18n.t('delete')}"
          end
          
          it 'should destroy the object' do
            lambda do
              sleep(2)
            end.should change(CertificateCandidate,:count).by(-1)
          end
          
          it "shouldn't have an edit form anymore" do
            page.should_not have_selector "div#edit_certificate_candidate_#{@certificate_candidate.id}"
          end

          it "shouldn't have a show block anymore" do
            page.should_not have_selector "div#show_certificate_candidate_#{@certificate_candidate.id}"
          end
          
          it 'should have an empty block' do
            find('div#certificate_candidates').should have_content I18n.t('certificates.add_some')
          end
          
          it "should have a new form when an object was just destroyed and 'ADD +' is clicked" do
            sleep(2)
            click_link 'link_add_certificate_candidate'
            page.should have_selector 'form#new_certificate_candidate'
            find('form#new_certificate_candidate').find('div.certificate_candidate')
          end
        end
      end

      describe 'languages' do

        before :each do
          @language_candidate = Factory :language_candidate, :candidate => @candidate
          visit signin_path
          fill_in 'email',    :with => @candidate.email
          fill_in 'password', :with => @candidate.password
          click_button "#{I18n.t('sessions.new.signin')}"
          visit candidate_path @candidate
        end
        
        it "should have an empty form after 'ADD +' is clicked" do
          click_link 'link_add_language_candidate'
          page.should have_selector 'form#new_language_candidate'
          find('form#new_language_candidate').find('div.language_candidate')
        end
        
        it "should have a hidden form after 'Cancel' is clicked" do
          click_link 'link_add_language_candidate'
          click_link "#{I18n.t('cancel')}"
          find('form#new_language_candidate').visible?.should be_false
        end
        
        it 'should have an error message when an empty form is submitted' do
          click_link 'link_add_language_candidate'
          click_button "#{I18n.t('submit')}"
          find('form#new_language_candidate').visible?.should be_true
          find('div#errors_new_language_candidate').should have_content 'language.label'
        end

        it 'should have a hidden show block and a visible edit block when clicked' do
          find("div#show_language_candidate_#{@language_candidate.id}").click
          find("div#edit_language_candidate_#{@language_candidate.id}").visible?.should be_true
          find("div#show_language_candidate_#{@language_candidate.id}").visible?.should be_false
        end
        
        describe 'create' do
          
          before :each do
            click_link 'link_add_language_candidate'
            fill_in 'language_candidate_language_attributes_label', :with => 'Swedish'
            page.select(I18n.t('skills.beginner'), :from => 'language_candidate_level')
            click_button "#{I18n.t('submit')}"             
          end
          
          it 'should create a new object' do
            lambda do              
              sleep(2)          
            end.should change(LanguageCandidate, :count).by(1)
          end
          
          it "shouldn't have a new form anymore" do
            page.should_not have_selector 'form#new_language_candidate'
          end                       
        end

        describe 'update' do
          
          before :each do
            find("div#show_language_candidate_#{@language_candidate.id}").click
          end
          
          it 'should have an error message when a field is deleted' do
            fill_in 'language_candidate_language_attributes_label', :with => ''
            click_button "#{I18n.t('submit')}"
            find("div#edit_language_candidate_#{@language_candidate.id}").visible?.should be_true
            find("div.error_messages").should have_content 'language.label'
          end
          
          it 'should have the updated details and a hidden edit form when correct data is submitted' do
            fill_in 'language_candidate_language_attributes_label', :with => 'Norwich'
            click_button "#{I18n.t('submit')}"
            sleep(2)
            find("div#edit_language_candidate_#{@language_candidate.id}").visible?.should be_false
            find("div#show_language_candidate_#{@language_candidate.id}").should have_content 'Norwich'
          end
        end
        
        describe 'destroy' do
          
          before :each do
            find("div#show_language_candidate_#{@language_candidate.id}").click
            click_link "#{I18n.t('delete')}"
          end
          
          it 'should destroy the object' do
            lambda do
              sleep(2)
            end.should change(LanguageCandidate,:count).by(-1)
          end
          
          it "shouldn't have an edit form anymore" do
            page.should_not have_selector "div#edit_language_candidate_#{@language_candidate.id}"
          end

          it "shouldn't have a show block anymore" do
            page.should_not have_selector "div#show_language_candidate_#{@language_candidate.id}"
          end
          
          it 'should have an empty block' do
            find('div#language_candidates').should have_content I18n.t('languages.add_some')
          end
          
          it "should have a new form when an object was just destroyed and 'ADD +' is clicked" do
            sleep(2)
            click_link 'link_add_language_candidate'
            page.should have_selector 'form#new_language_candidate'
            find('form#new_language_candidate').find('div.language_candidate')
          end
        end        
      end                   
    end
  end
end
