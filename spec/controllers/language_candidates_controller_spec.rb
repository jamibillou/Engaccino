require 'spec_helper'

describe LanguageCandidatesController do
  
  render_views

  before :each do
    @candidate          = Factory :candidate
    @language_candidate = Factory :language_candidate, :candidate => @candidate
    @attr               = { :candidate_id => @candidate, :language_attributes => { :label => 'Portugesh' }, :level => 'native' }
  end

  describe "GET 'new'" do
    
    before :each do
      test_sign_in @candidate
      xhr :get, :new
    end
      
    it 'should respond http success' do
      response.should be_success
    end
      
    it 'should render the new form' do
      response.should render_template :partial => '_new_form'
    end
  end
  
  describe "POST 'create'" do

    before :each do
      test_sign_in @candidate
    end
      
    describe 'failure' do
        
      before :each do
        lambda do
          xhr :post, :create, :language_candidate => @attr.merge(:language_attributes => { :label => '' }, :level => '')
        end.should_not change(LanguageCandidate, :count)
      end
        
      it 'should fail with blank attributes' do
        response.should_not be_success
      end
        
      it 'should respond with the right error message' do
        response.body.should include 'language.label', 'mandatory', 'level', 'invalid'
      end
    end
      
    describe 'success' do
        
      before :each do
        lambda do
          xhr :post, :create, :language_candidate => @attr
        end.should change(LanguageCandidate, :count).by 1
      end 
        
      it 'should respond http success' do
        response.should be_success
      end
        
      it 'should respond with the right json message' do
        response.body.should == 'create!'
      end    
    end      
  end
  
  describe "GET 'edit'" do
    
    before :each do
      test_sign_in @candidate
      xhr :get, :edit, :id => @language_candidate
    end
      
    it 'should respond http success' do
      response.should be_success
    end
      
    it 'should render the edit form' do
      response.should render_template :partial => '_edit_form'
    end
  end
  
  describe "PUT 'update'" do
      
    before :each do
      test_sign_in @candidate
    end
      
    describe 'success' do
        
      before :each do
        @updated_attr = @attr.merge(:language_attributes => { :label => 'German' }, :level => 'beginner')
      end
        
      it 'should update the language_candidate' do
        xhr :put, :update, :language_candidate => @updated_attr, :id => @language_candidate
        updated_language_candidate = assigns :language_candidate
        @language_candidate.reload
        @language_candidate.level.should == updated_language_candidate.level
      end
        
      it 'should not create a new language_candidate' do
        lambda do
          xhr :put, :update, :language_candidate => @updated_attr, :id => @language_candidate
        end.should_not change(LanguageCandidate, :count)
      end
        
      it 'should create a language' do
        lambda do
          xhr :put, :update, :language_candidate => @updated_attr, :id => @language_candidate
        end.should change(Language, :count).by 1
      end
        
      it 'should respond with the right json message' do
        xhr :put, :update, :language_candidate => @updated_attr, :id => @language_candidate
        response.body.should == 'update!'
      end 
    end
      
    describe 'failure' do
        
      it 'should render the right error message' do
        xhr :put, :update, :language_candidate => @attr.merge(:language_attributes => { :label => '' }, :level => ''), :id => @language_candidate  
        response.body.should include 'language.label', 'mandatory', 'level', 'invalid'
      end
    end  
  end
  
  describe "DESTROY 'delete'" do
    
    describe 'for non-signed-in users' do
      
      it "should deny access to 'delete'" do
        delete :destroy, :id => @language_candidate
        response.should redirect_to signin_path
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe 'for signed-in candidates' do
      
      before :each do
        test_sign_in @candidate
        lambda do
          xhr :delete, :destroy, :id => @language_candidate
        end.should change(LanguageCandidate, :count).by -1
      end
      
      it 'should respond http success' do
        response.should be_success
      end
      
      it 'should respond with the right json message' do
        response.body.should == 'destroy!'
      end       
    end    
  end
end