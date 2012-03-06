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
        response.should have_selector 'div.flash.error', :content => I18n.t('flash.error.base')
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
        @candidate.update_attributes :profile_completion => 5
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
    end
  end
end
