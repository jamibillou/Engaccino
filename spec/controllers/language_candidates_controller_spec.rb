require 'spec_helper'

describe LanguageCandidatesController do
  render_views

  before :each do
    @candidate = Factory :candidate
    @language_candidate = Factory :language_candidate, :candidate => @candidate
  end

  describe "GET 'new'" do
    
    describe 'for non-signed-in candidates' do
      
      it "should deny access to 'new'" do
        get :new
        response.should redirect_to signin_path
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe 'for signed-in candidates' do
      
      before(:each) do
        test_sign_in @candidate
      end
      
      describe 'failure' do
        
        it 'should fail using the html format' do
          get :new
          response.should redirect_to @candidate
          flash[:notice].should == I18n.t('flash.notice.restricted_page')
        end
      end
      
      describe 'success' do
        it 'should respond http success' do
          xhr :get, :new
          response.should be_success
        end
      
        it 'should display the correct form' do
          xhr :get, :new
          response.should render_template(:partial => '_new_form')
        end
      end      
    end  
  end
  
  describe "POST 'create'" do
    
    describe 'for non-signed-in candidates' do
      
      it "should deny access to 'create'" do
        post :create
        response.should redirect_to signin_path
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe 'for signed-in candidates' do
      
      before :each do
        test_sign_in @candidate
      end
      
      describe 'failure' do
        
        before :each do
          @attr = { :candidate_id => @candidate, :language_attributes => { :label => '' }, :level => '' }
        end
        
        it 'should fail with blank attributes' do
          xhr :post, :create, :language_candidate => @attr
          response.should_not be_success
        end
        
        it 'should respond with the error messages' do
          xhr :post, :create, :language_candidate => @attr
          response.body.should include("language.label","can't be blank","level","is not included in the list")
        end
      end
      
      describe 'success' do
        
        before :each do
          @attr = { :candidate_id => @candidate, :language_attributes => { :label => 'Portugesh' }, :level => 'native' }
        end
        
        it 'should respond http success' do
          xhr :post, :create, :language_candidate => @attr
          response.should be_success
        end
        
        it 'should respond with the correct json message' do
          xhr :post, :create, :language_candidate => @attr
          response.body.should == 'create!'
        end    
      
        it 'should create a language_candidate object' do
          lambda do
            xhr :post, :create, :language_candidate => @attr
          end.should change(LanguageCandidate, :count).by(1)
        end
      end      
    end    
  end
  
  describe "GET 'edit'" do
    
    describe 'for non-signed-in candidates' do
      
      it "should deny access to 'edit'" do
        get :edit
        response.should redirect_to signin_path
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe 'for signed-in candidates' do
      
      before(:each) do
        test_sign_in @candidate
      end
      
      describe 'failure' do
        
        it 'should fail using the html format' do
          get :edit, :id => @language_candidate
          response.should redirect_to @candidate
          flash[:notice].should == I18n.t('flash.notice.restricted_page')
        end
      end
      
      describe 'success' do
        it 'should respond http success' do
          xhr :get, :edit, :id => @language_candidate
          response.should be_success
        end
      
        it 'should display the correct form' do
          xhr :get, :edit, :id => @language_candidate
          response.should render_template(:partial => '_edit_form')
        end
      end      
    end  
  end
  
  describe "PUT 'update'" do
    
    describe 'for non-signed-in candidates' do
      
      it "should deny access to 'update'" do
        put :update, :id => @language_candidate
        response.should redirect_to signin_path
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe 'for signed-in candidates' do
      
      before :each do
        test_sign_in @candidate
      end
      
      describe 'success' do
        
        before :each do
          @attr = { :language_candidate => { :candidate_id => @candidate, :language_attributes => { :label => 'German' }, :level => 'beginner' } }
        end
        
        it 'should update the language_candidate object ' do
          xhr :put, :update, :language_candidate => @attr[:language_candidate], :id => @language_candidate
          language_candidate = assigns :language_candidate
          @language_candidate.reload
          @language_candidate.level == language_candidate.level
        end
        
        it 'should not create a language_candidate' do
          lambda do
            xhr :put, :update, :language_candidate => @attr[:language_candidate], :id => @language_candidate
          end.should_not change(LanguageCandidate, :count)
        end
        
        it 'should create a language' do
          lambda do
            xhr :put, :update, :language_candidate => @attr[:language_candidate], :id => @language_candidate
          end.should change(Language, :count).by(1)
        end
        
        it 'should respond with the correct json message' do
          xhr :put, :update, :language_candidate => @attr[:language_candidate], :id => @language_candidate
          response.body.should == 'update!'
        end 
      end
      
      describe 'failure' do
        
        before :each do
          @attr = { :language_candidate => { :candidate_id => @candidate, :language_attributes => { :label => '' }, :level => '' } }
        end
        
        it 'should render the correct error message' do
          xhr :put, :update, :language_candidate => @attr[:language_candidate], :id => @language_candidate  
          response.body.should include("language.label","can't be blank","level","is not included in the list")
        end
      
        it 'should not create another language_candidate object' do
          lambda do
            xhr :put, :update, :language_candidate => @attr[:language_candidate], :id => @language_candidate
          end.should_not change(LanguageCandidate, :count)
        end
      end  
    end   
  end
  
  describe "DESTROY 'delete'" do
    
    describe 'for non-signed-in candidates' do
      
      it "should deny access to 'delete'" do
        delete :destroy, :id => @language_candidate
        response.should redirect_to signin_path
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe 'for signed-in candidates' do
      
      before :each do
        test_sign_in @candidate
      end
      
      it 'should respond http success' do
        xhr :delete, :destroy, :id => @language_candidate
        response.should be_success
      end
      
      it 'should respond with the correct json message' do
        xhr :delete, :destroy, :id => @language_candidate
        response.body.should == 'destroy!'
      end    
    
      it 'should destroy the selected language_candidate object' do
        lambda do
          xhr :delete, :destroy, :id => @language_candidate
        end.should change(LanguageCandidate, :count).by(-1)
      end   
    end    
  end
end
