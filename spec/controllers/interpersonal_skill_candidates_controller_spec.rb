require 'spec_helper'

describe InterpersonalSkillCandidatesController do
  render_views

  before :each do
    @candidate = Factory :candidate
    @interpersonal_skill_candidate = Factory :interpersonal_skill_candidate, :candidate => @candidate
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
          @attr = { :candidate_id => @candidate, :interpersonal_skill_attributes => { :label => '' } }
        end
        
        it 'should fail with a blank skill label' do
          xhr :post, :create, :interpersonal_skill_candidate => @attr
          response.should_not be_success
        end
        
        it 'should respond with the error messages' do
          xhr :post, :create, :interpersonal_skill_candidate => @attr
          response.body.should include("interpersonal_skill.label","mandatory")
        end
      end
      
      describe 'success' do
        
        before :each do
          @attr = { :candidate_id => @candidate, :interpersonal_skill_attributes => { :label => 'Bravery' } }
        end
        
        it 'should respond http success' do
          xhr :post, :create, :interpersonal_skill_candidate => @attr
          response.should be_success
        end
        
        it 'should respond with the correct json message' do
          xhr :post, :create, :interpersonal_skill_candidate => @attr
          response.body.should == 'create!'
        end    
      
        it 'should create a interpersonal_skill_candidate object' do
          lambda do
            xhr :post, :create, :interpersonal_skill_candidate => @attr
          end.should change(InterpersonalSkillCandidate, :count).by(1)
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
          get :edit, :id => @interpersonal_skill_candidate
          response.should redirect_to @candidate
          flash[:notice].should == I18n.t('flash.notice.restricted_page')
        end
      end
      
      describe 'success' do
        it 'should respond http success' do
          xhr :get, :edit, :id => @interpersonal_skill_candidate
          response.should be_success
        end
      
        it 'should display the correct form' do
          xhr :get, :edit, :id => @interpersonal_skill_candidate
          response.should render_template(:partial => '_edit_form')
        end
      end      
    end  
  end
  
  describe "PUT 'update'" do
    
    describe 'for non-signed-in candidates' do
      
      it "should deny access to 'update'" do
        put :update, :id => @interpersonal_skill_candidate
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
          @attr = { :interpersonal_skill_candidate => { :candidate_id => @candidate, :interpersonal_skill_attributes => { :label => 'Luck' } } }
        end
        
        it 'should update the interpersonal_skill_candidate object ' do
          xhr :put, :update, :interpersonal_skill_candidate => @attr[:interpersonal_skill_candidate], :id => @interpersonal_skill_candidate
          interpersonal_skill_candidate = assigns :interpersonal_skill_candidate
          @interpersonal_skill_candidate.reload
          @interpersonal_skill_candidate.interpersonal_skill.label == interpersonal_skill_candidate.interpersonal_skill.label
        end
        
        it 'should not create a interpersonal_skill_candidate' do
          lambda do
            xhr :put, :update, :interpersonal_skill_candidate => @attr[:interpersonal_skill_candidate], :id => @interpersonal_skill_candidate
          end.should_not change(InterpersonalSkillCandidate, :count)
        end
        
        it 'should create an interpersonal_skill' do
          lambda do
            xhr :put, :update, :interpersonal_skill_candidate => @attr[:interpersonal_skill_candidate], :id => @interpersonal_skill_candidate
          end.should change(InterpersonalSkill, :count).by(1)
        end
        
        it 'should respond with the correct json message' do
          xhr :put, :update, :interpersonal_skill_candidate => @attr[:interpersonal_skill_candidate], :id => @interpersonal_skill_candidate
          response.body.should == 'update!'
        end 
      end
      
      describe 'failure' do
        
        before :each do
          @attr = { :interpersonal_skill_candidate => { :candidate_id => @candidate, :interpersonal_skill_attributes => { :label => '' } } }
        end
        
        it 'should render the correct error message' do
          xhr :put, :update, :interpersonal_skill_candidate => @attr[:interpersonal_skill_candidate], :id => @interpersonal_skill_candidate  
          response.body.should include("interpersonal_skill.label","mandatory")
        end
      
        it 'should not create another interpersonal_skill_candidate object' do
          lambda do
            xhr :put, :update, :interpersonal_skill_candidate => @attr[:interpersonal_skill_candidate], :id => @interpersonal_skill_candidate
          end.should_not change(InterpersonalSkillCandidate, :count)
        end
      end  
    end   
  end
  
  describe "DESTROY 'delete'" do
    
    describe 'for non-signed-in candidates' do
      
      it "should deny access to 'delete'" do
        delete :destroy, :id => @interpersonal_skill_candidate
        response.should redirect_to signin_path
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe 'for signed-in candidates' do
      
      before :each do
        test_sign_in @candidate
      end
      
      it 'should respond http success' do
        xhr :delete, :destroy, :id => @interpersonal_skill_candidate
        response.should be_success
      end
      
      it 'should respond with the correct json message' do
        xhr :delete, :destroy, :id => @interpersonal_skill_candidate
        response.body.should == 'destroy!'
      end    
    
      it 'should destroy the selected interpersonal_skill_candidate object' do
        lambda do
          xhr :delete, :destroy, :id => @interpersonal_skill_candidate
        end.should change(InterpersonalSkillCandidate, :count).by(-1)
      end   
    end    
  end
end
