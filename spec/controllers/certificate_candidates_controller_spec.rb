require 'spec_helper'

describe CertificateCandidatesController do
  
  render_views

  before :each do
    @candidate             = Factory :candidate
    @certificate_candidate = Factory :certificate_candidate, :candidate => @candidate
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
        xhr :post, :create, :certificate_candidate => { :candidate_id => @candidate, :certificate_attributes => { :label => '' }, :level_score => '' }
      end
        
      it 'should fail with a blank label' do
        response.should_not be_success
      end
        
      it 'should respond with the error messages' do
        response.body.should include("certificate.label","mandatory")
      end
    end
      
    describe 'success' do
        
      before :each do
        lambda do
          xhr :post, :create, :certificate_candidate => { :candidate_id => @candidate, :certificate_attributes => { :label => 'TOEIC' }, :level_score => 'AAA' }
        end.should change(CertificateCandidate, :count).by 1
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
      xhr :get, :edit, :id => @certificate_candidate
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
        @attr = { :candidate_id => @candidate, :certificate_attributes => { :label => 'BEPC' }, :level_score => 'BBB' }
      end
        
      it 'should update the certificate_candidate object ' do
        xhr :put, :update, :certificate_candidate => @attr, :id => @certificate_candidate
        certificate_candidate = assigns :certificate_candidate
        @certificate_candidate.reload
        @certificate_candidate.level_score.should == certificate_candidate.level_score
      end
        
      it 'should not create a new certificate_candidate' do
        lambda do
          xhr :put, :update, :certificate_candidate => @attr, :id => @certificate_candidate
        end.should_not change(CertificateCandidate, :count)
      end
        
      it 'should create a certificate' do
        lambda do
          xhr :put, :update, :certificate_candidate => @attr, :id => @certificate_candidate
        end.should change(Certificate, :count).by 1
      end
        
      it 'should respond with the right json message' do
        xhr :put, :update, :certificate_candidate => @attr, :id => @certificate_candidate
        response.body.should == 'update!'
      end 
    end
      
    describe 'failure' do

      it 'should have the right error messages' do
        xhr :put, :update, :certificate_candidate => { :candidate_id => @candidate, :certificate_attributes => { :label => '' }, :level_score => '' }, :id => @certificate_candidate  
        response.body.should include("certificate.label", "mandatory")
      end
    end  
  end
  
  describe "DESTROY 'delete'" do
    
    describe 'for non-signed-in users' do
      
      it "should deny access to 'delete'" do
        delete :destroy, :id => @certificate_candidate
        response.should redirect_to signin_path
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe 'for signed-in candidates' do
      
      before :each do
        test_sign_in @candidate
        lambda do
          xhr :delete, :destroy, :id => @certificate_candidate
        end.should change(CertificateCandidate, :count).by -1
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
