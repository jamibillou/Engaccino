require 'spec_helper'

describe SearchController do
  
  render_views
  
  before :each do    
    @param = 'test'
    @candidate = Factory   :candidate, :last_name => 'testo',     :profile_completion => 5
    @candidate2 = Factory  :candidate, :last_name => 'hollande',  :profile_completion => 5
    @recruiter = Factory   :recruiter, :first_name => 'testo',    :profile_completion => 5
    @recruiter2 = Factory  :recruiter, :first_name => 'francois', :profile_completion => 5
  end

  describe "GET 'index'" do
    
    describe 'candidate part' do
      before :each do
        test_sign_in @candidate
        get :index, {:search => @param}
      end
      
      it 'should return http success' do
        response.should be_success
      end
      
      it 'should have the right title' do
        response.body.should have_selector 'h1', :text => "#{I18n.t('search.title')} #{@search}"
      end
      
      it 'should have a card for the matching recruiter' do
        response.body.should have_selector 'div', :id => "recruiter_#{@recruiter.id}"
      end

      it "shouldn't have a card for the non-matching recruiter" do
        response.body.should_not include "recruiter_#{@recruiter2.id}"
      end
    end
    
    describe 'recruiter part' do
      before :each do
        test_sign_in @recruiter
        get :index, {:search => @param}
      end
      
      it 'should have a card for the matching candidate' do
        response.body.should have_selector 'div', :id => "candidate_#{@candidate.id}"
      end

      it "shouldn't have a card for the non-matching candidate" do
        response.body.should_not include "candidate_#{@candidate2.id}"
      end
    end    
  end

end
