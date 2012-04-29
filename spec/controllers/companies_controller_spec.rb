require 'spec_helper'

describe CompaniesController do
  
  before :each do
    @company   = Factory :company
    @candidate = Factory :candidate, :profile_completion => 5
  end
  
  describe "GET 'show'" do
      
    describe 'for candidates' do
        
      before :each do
        test_sign_in @candidate
        get :show, :id => @company
      end
        
      it 'should return http success' do
        response.should be_success
      end
      
      it 'should not have a selected tab' do
        response.body.should_not have_selector 'li', :class => 'round selected'   
      end
    end
  end
end
