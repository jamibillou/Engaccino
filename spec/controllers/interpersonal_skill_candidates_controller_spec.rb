require 'spec_helper'

describe InterpersonalSkillCandidatesController do
  
  render_views

  before :each do
    @candidate                     = Factory :candidate, :profile_completion => 5
    @interpersonal_skill_candidate = Factory :interpersonal_skill_candidate, :candidate => @candidate
    @attr                          = { :candidate_id => @candidate, :interpersonal_skill_attributes => { :label => 'Vailliance' } }
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
          xhr :post, :create, :interpersonal_skill_candidate => @attr.merge(:interpersonal_skill_attributes => { :label => '' })
        end.should_not change(InterpersonalSkillCandidate, :count)
      end
        
      it 'should fail with a blank label' do
        response.should_not be_success
      end
        
      it 'should respond with the right error message' do
        response.body.should include 'interpersonal_skill.label', 'mandatory'
      end
    end
      
    describe 'success' do
      
      before :each do
        lambda do
          xhr :post, :create, :interpersonal_skill_candidate => @attr
        end.should change(InterpersonalSkillCandidate, :count).by 1
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
      xhr :get, :edit, :id => @interpersonal_skill_candidate
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
        @updated_attr = @attr.merge(:interpersonal_skill_attributes => { :label => 'Ultimate opportunist' })
      end
        
      it 'should update the interpersonal_skill_candidate' do
        xhr :put, :update, :interpersonal_skill_candidate => @updated_attr, :id => @interpersonal_skill_candidate
        updated_interpersonal_skill_candidate = assigns :interpersonal_skill_candidate
        @interpersonal_skill_candidate.reload
        @interpersonal_skill_candidate.interpersonal_skill.label.should == updated_interpersonal_skill_candidate.interpersonal_skill.label
      end
        
      it 'should not create a new interpersonal_skill_candidate' do
        lambda do
          xhr :put, :update, :interpersonal_skill_candidate => @updated_attr, :id => @interpersonal_skill_candidate
        end.should_not change(InterpersonalSkillCandidate, :count)
      end
        
      it 'should create an interpersonal_skill' do
        lambda do
          xhr :put, :update, :interpersonal_skill_candidate => @updated_attr, :id => @interpersonal_skill_candidate
        end.should change(InterpersonalSkill, :count).by 1
      end
        
      it 'should respond with the right json message' do
        xhr :put, :update, :interpersonal_skill_candidate => @updated_attr, :id => @interpersonal_skill_candidate
        response.body.should == 'update!'
      end 
    end
      
    describe 'failure' do
        
      it 'should respond the right error message' do
        xhr :put, :update, :interpersonal_skill_candidate => @attr.merge(:interpersonal_skill_attributes => { :label => '' }), :id => @interpersonal_skill_candidate  
        response.body.should include 'interpersonal_skill.label', 'mandatory'
      end
    end   
  end
  
  describe "DESTROY 'delete'" do
    
    describe 'for non-signed-in users' do
      
      it "should deny access to 'delete'" do
        delete :destroy, :id => @interpersonal_skill_candidate
        response.should redirect_to signin_path
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe 'for signed-in candidates' do
      
      before :each do
        test_sign_in @candidate
        lambda do
          xhr :delete, :destroy, :id => @interpersonal_skill_candidate
        end.should change(InterpersonalSkillCandidate, :count).by -1
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