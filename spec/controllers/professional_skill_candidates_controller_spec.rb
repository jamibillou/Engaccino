require 'spec_helper'

describe ProfessionalSkillCandidatesController do
  
  render_views

  before :each do
    @candidate = Factory :candidate
    @professional_skill_candidate = Factory :professional_skill_candidate, :candidate => @candidate
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
          @attr = { :candidate_id => @candidate, :professional_skill_candidate => { :label => '' }, :level => '', :experience => '' }
        end
        
        it 'should fail with blank attributes' do
          xhr :post, :create, :professional_skill_candidate => @attr
          response.should_not be_success
        end
        
        it 'should respond with the error messages' do
          xhr :post, :create, :professional_skill_candidate => @attr
          response.body.should include("level","experience","mandatory")
        end
      end
      
      describe 'success' do
        
        before :each do
          @attr = { :candidate_id => @candidate, :professional_skill_attributes => { :label => 'Bravery' }, :level => 'intermediate', :experience => '3' }
        end
        
        it 'should respond http success' do
          xhr :post, :create, :professional_skill_candidate => @attr
          response.should be_success
        end
        
        it 'should respond with the correct json message' do
          xhr :post, :create, :professional_skill_candidate => @attr
          response.body.should == 'create!'
        end    
      
        it 'should create a professional_skill_candidate object' do
          lambda do
            xhr :post, :create, :professional_skill_candidate => @attr
          end.should change(ProfessionalSkillCandidate, :count).by(1)
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
          get :edit, :id => @professional_skill_candidate
          response.should redirect_to @candidate
          flash[:notice].should == I18n.t('flash.notice.restricted_page')
        end
      end
      
      describe 'success' do
        it 'should respond http success' do
          xhr :get, :edit, :id => @professional_skill_candidate
          response.should be_success
        end
      
        it 'should display the correct form' do
          xhr :get, :edit, :id => @professional_skill_candidate
          response.should render_template(:partial => '_edit_form')
        end
      end      
    end  
  end
  
  describe "PUT 'update'" do
    
    describe 'for non-signed-in candidates' do
      
      it "should deny access to 'update'" do
        put :update, :id => @professional_skill_candidate
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
          @attr = { :professional_skill_candidate => { :candidate_id => @candidate, :professional_skill_attributes => { :label => 'Luck' }, :level => 'expert', :experience => '5' } }
        end
        
        it 'should update the professional_skill_candidate object ' do
          xhr :put, :update, :professional_skill_candidate => @attr[:professional_skill_candidate], :id => @professional_skill_candidate
          professional_skill_candidate = assigns :professional_skill_candidate
          @professional_skill_candidate.reload
          @professional_skill_candidate.level == professional_skill_candidate.level
          @professional_skill_candidate.experience == professional_skill_candidate.experience
        end
        
        it 'should not create a professional_skill_candidate' do
          lambda do
            xhr :put, :update, :professional_skill_candidate => @attr[:professional_skill_candidate], :id => @professional_skill_candidate
          end.should_not change(ProfessionalSkillCandidate, :count)
        end
        
        it 'should create a professional_skill' do
          lambda do
            xhr :put, :update, :professional_skill_candidate => @attr[:professional_skill_candidate], :id => @professional_skill_candidate
          end.should change(ProfessionalSkill, :count).by(1)
        end
        
        it 'should respond with the correct json message' do
          xhr :put, :update, :professional_skill_candidate => @attr[:professional_skill_candidate], :id => @professional_skill_candidate
          response.body.should == 'update!'
        end 
      end
      
      describe 'failure' do
        
        before :each do
          @attr = { :professional_skill_candidate => { :candidate_id => @candidate, :professional_skill_candidate => { :label => '' }, :experience => '', :level => '' } }
        end
        
        it 'should render the correct error message' do
          xhr :put, :update, :professional_skill_candidate => @attr[:professional_skill_candidate], :id => @professional_skill_candidate  
          response.body.should include("level","experience","mandatory")
        end
      
        it 'should not create another professional_skill_candidate object' do
          lambda do
            xhr :put, :update, :professional_skill_candidate => @attr[:professional_skill_candidate], :id => @professional_skill_candidate
          end.should_not change(ProfessionalSkillCandidate, :count)
        end
      end  
    end   
  end
  
  describe "DESTROY 'delete'" do
    
    describe 'for non-signed-in candidates' do
      
      it "should deny access to 'delete'" do
        delete :destroy, :id => @professional_skill_candidate
        response.should redirect_to signin_path
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe 'for signed-in candidates' do
      
      before :each do
        test_sign_in @candidate
      end
      
      it 'should respond http success' do
        xhr :delete, :destroy, :id => @professional_skill_candidate
        response.should be_success
      end
      
      it 'should respond with the correct json message' do
        xhr :delete, :destroy, :id => @professional_skill_candidate
        response.body.should == 'destroy!'
      end    
    
      it 'should destroy the selected professional_skill_candidate object' do
        lambda do
          xhr :delete, :destroy, :id => @professional_skill_candidate
        end.should change(ProfessionalSkillCandidate, :count).by(-1)
      end   
    end    
  end
end
