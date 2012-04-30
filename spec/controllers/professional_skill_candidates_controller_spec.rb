require 'spec_helper'

describe ProfessionalSkillCandidatesController do
  
  render_views

  before :each do
    @candidate                    = Factory :candidate
    @professional_skill_candidate = Factory :professional_skill_candidate, :candidate => @candidate
    @attr                         = { :candidate_id => @candidate, :professional_skill_attributes => { :label => 'Vailliance' }, :level => 'intermediate', :experience => '3' }
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
          xhr :post, :create, :professional_skill_candidate => @attr.merge(:professional_skill_candidate => { :label => '' }, :level => '', :experience => '')
        end.should_not change(ProfessionalSkillCandidate, :count)
      end
        
      it 'should fail with blank attributes' do
        response.should_not be_success
      end
        
      it 'should respond with the right error message' do
        response.body.should include 'level', 'experience', 'mandatory'
      end
    end
      
    describe 'success' do
      
      before :each do
        lambda do
          xhr :post, :create, :professional_skill_candidate => @attr
        end.should change(ProfessionalSkillCandidate, :count).by 1
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
      xhr :get, :edit, :id => @professional_skill_candidate
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
        @updated_attr = @attr.merge(:professional_skill_attributes => { :label => 'Overall greatness' }, :level => 'expert', :experience => '5')
      end
        
      it 'should update the professional_skill_candidate' do
        xhr :put, :update, :professional_skill_candidate => @updated_attr, :id => @professional_skill_candidate
        updated_professional_skill_candidate = assigns :professional_skill_candidate
        @professional_skill_candidate.reload
        @professional_skill_candidate.level.should      == updated_professional_skill_candidate.level
        @professional_skill_candidate.experience.should == updated_professional_skill_candidate.experience
      end
        
      it 'should not create a new professional_skill_candidate' do
        lambda do
          xhr :put, :update, :professional_skill_candidate => @updated_attr, :id => @professional_skill_candidate
        end.should_not change(ProfessionalSkillCandidate, :count)
      end
        
      it 'should create a professional_skill' do
        lambda do
          xhr :put, :update, :professional_skill_candidate => @updated_attr, :id => @professional_skill_candidate
        end.should change(ProfessionalSkill, :count).by 1
      end
        
      it 'should respond with the right json message' do
        xhr :put, :update, :professional_skill_candidate => @updated_attr, :id => @professional_skill_candidate
        response.body.should == 'update!'
      end 
    end
      
    describe 'failure' do

      it 'should render the right error message' do
        xhr :put, :update, :professional_skill_candidate => @attr.merge(:professional_skill_candidate => { :label => '' }, :experience => '', :level => ''), :id => @professional_skill_candidate  
        response.body.should include 'level', 'experience', 'mandatory'
      end
    end  
  end
  
  describe "DESTROY 'delete'" do
    
    describe 'for non-signed-in users' do
      
      it "should deny access to 'delete'" do
        delete :destroy, :id => @professional_skill_candidate
        response.should redirect_to signin_path
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe 'for signed-in candidates' do
      
      before :each do
        test_sign_in @candidate
        lambda do
          xhr :delete, :destroy, :id => @professional_skill_candidate
        end.should change(ProfessionalSkillCandidate, :count).by -1
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