require 'spec_helper'

describe 'Recruiters' do

  describe 'signup' do
    
    describe 'failure' do
      
      it 'should not sign a recruiter up' do
        visit recruiter_signup_path
        fill_in 'recruiter_email',                 :with => 'test@example.com'
        fill_in 'recruiter_password',              :with => 'password'
        fill_in 'recruiter_password_confirmation', :with => 'passwordd'
        click_button "#{I18n.t('recruiters.new.set_up_profile')}"
        current_path.should == recruiters_path
      end
    end
    
    describe 'success' do
      
      it 'should sign a recruiter up and display his profile page' do
        visit recruiter_signup_path
        fill_in 'recruiter_email',                 :with => 'test@example.com'
        fill_in 'recruiter_password',              :with => 'password'
        fill_in 'recruiter_password_confirmation', :with => 'password'
        click_button "#{I18n.t('recruiters.new.set_up_profile')}"
        fill_in 'recruiter_first_name',            :with => 'Jack'
        fill_in 'recruiter_last_name',             :with => 'Bauer'
        fill_in 'recruiter_city',                  :with => 'Washington D.C.'
        fill_in 'recruiter_country',               :with => 'United States'
        click_button "#{I18n.t('recruiters.show.view_profile')}"
        current_path.should == recruiter_path(Recruiter.find_by_email('test@example.com'))
      end
    end
  end

  describe 'signin / signout' do
  
    describe 'failure' do
    
      it 'should not sign a recruiter in' do
        visit signin_path
        fill_in 'email',    :with => ''
        fill_in 'password', :with => ''
        click_button "#{I18n.t('sessions.new.signin')}"
        find('div.flash.error').should have_content I18n.t('flash.error.signin')
      end
    end
  
    describe 'success' do
    
      before :each do
        @recruiter = Factory :recruiter
        @recruiter.update_attributes :profile_completion => 5
      end
      
      it 'should sign a recruiter in' do
        visit signin_path
        fill_in 'email',    :with => @recruiter.email
        fill_in 'password', :with => @recruiter.password
        click_button "#{I18n.t('sessions.new.signin')}"
        current_path.should == recruiter_path(@recruiter)
      end
      
      it 'should sign a recruiter out' do
        visit signin_path
        fill_in 'email',    :with => @recruiter.email
        fill_in 'password', :with => @recruiter.password
        click_button "#{I18n.t('sessions.new.signin')}"
        click_link I18n.t(:sign_out)
        current_path.should == root_path
      end      
    end
  end
  
  describe 'profile' do
    
    before :each do
      @recruiter = Factory :recruiter
      @recruiter.update_attributes :profile_completion => 5
      visit signin_path
      fill_in 'email',    :with => @recruiter.email
      fill_in 'password', :with => @recruiter.password
      click_button "#{I18n.t('sessions.new.signin')}"
    end
    
    describe 'when empty' do
      
      before :each do
        Company.destroy(@recruiter.company.id)
        visit recruiter_path @recruiter
      end
      
      it 'should have a recruiter card' do
        page.should have_selector 'div.card'
      end
      
      it 'should not have a company block' do
        page.should_not have_selector "div#company_#{@recruiter.company.id}"
      end
    end    
    
    describe 'when complete' do
      
      it 'should have a recruiter card' do
        page.should have_selector 'div.card'
      end
      
      it 'should have a company block' do
        page.should have_selector "div#company_#{@recruiter.company.id}"
      end
    end
  end
end