require 'spec_helper'

describe CompaniesController do
  
  before :each do
    @company   = Factory :company
    @candidate = Factory :candidate
  end
  
  describe "GET 'show'" do
      
    describe 'for candidates' do
        
      before :each do
        test_sign_in @candidate
        @candidate.update_attributes :profile_completion => 5
      end
        
      it 'should return http success' do
        get :show, :id => @company
        response.should be_success
      end
        
      # it 'should have the right selected navigation tab' do
      #   get :show, :id => @company
      #   response.should have_selector 'li', :class => 'round selected', :content => I18n.t(:menu_recruiters)
      # end
    end
  end
end
