require 'spec_helper'

describe CertificateCandidatesController do
  
  render_views

  before :each do
    @candidate = Factory :candidate
    @certificate_candidate = Factory :certificate_candidate, :candidate => @candidate
  end

  describe "GET 'new'" do
    
    before :each do
      test_sign_in @candidate
    end
      
    it 'should respond http success' do
      xhr :get, :new
      response.should be_success
    end
      
    it 'should display the correct form' do
      xhr :get, :new
      response.should render_template(:partial => '_new_form')
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
          @attr = { :candidate_id => @candidate, :certificate_attributes => { :label => '' }, :level_score => '' }
        end
        
        it 'should fail with a blank label' do
          xhr :post, :create, :certificate_candidate => @attr
          response.should_not be_success
        end
        
        it 'should respond with the error messages' do
          xhr :post, :create, :certificate_candidate => @attr
          response.body.should include("certificate.label","mandatory")
        end
      end
      
      describe 'success' do
        
        before :each do
          @attr = { :candidate_id => @candidate, :certificate_attributes => { :label => 'TOEIC' }, :level_score => 'AAA' }
        end
        
        it 'should respond http success' do
          xhr :post, :create, :certificate_candidate => @attr
          response.should be_success
        end
        
        it 'should respond with the correct json message' do
          xhr :post, :create, :certificate_candidate => @attr
          response.body.should == 'create!'
        end    
      
        it 'should create a certificate_candidate object' do
          lambda do
            xhr :post, :create, :certificate_candidate => @attr
          end.should change(CertificateCandidate, :count).by(1)
        end
      end      
    end    
  end
  
  describe "GET 'edit'" do
          
    before :each do
      test_sign_in @candidate
    end
      
    it 'should respond http success' do
      xhr :get, :edit, :id => @certificate_candidate
      response.should be_success
    end
      
    it 'should display the correct form' do
      xhr :get, :edit, :id => @certificate_candidate
      response.should render_template(:partial => '_edit_form')
    end
  end
  
  describe "PUT 'update'" do
    
    describe 'for non-signed-in candidates' do
      
      it "should deny access to 'update'" do
        put :update, :id => @certificate_candidate
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
          @attr = { :certificate_candidate => { :candidate_id => @candidate, :certificate_attributes => { :label => 'BEPC' }, :level_score => 'BBB' } }
        end
        
        it 'should update the certificate_candidate object ' do
          xhr :put, :update, :certificate_candidate => @attr[:certificate_candidate], :id => @certificate_candidate
          certificate_candidate = assigns :certificate_candidate
          @certificate_candidate.reload
          @certificate_candidate.level_score == certificate_candidate.level_score
        end
        
        it 'should not create a certificate_candidate' do
          lambda do
            xhr :put, :update, :certificate_candidate => @attr[:certificate_candidate], :id => @certificate_candidate
          end.should_not change(CertificateCandidate, :count)
        end
        
        it 'should create a certificate' do
          lambda do
            xhr :put, :update, :certificate_candidate => @attr[:certificate_candidate], :id => @certificate_candidate
          end.should change(Certificate, :count).by(1)
        end
        
        it 'should respond with the correct json message' do
          xhr :put, :update, :certificate_candidate => @attr[:certificate_candidate], :id => @certificate_candidate
          response.body.should == 'update!'
        end 
      end
      
      describe 'failure' do
        
        before :each do
          @attr = { :certificate_candidate => { :candidate_id => @candidate, :certificate_attributes => { :label => '' }, :level_score => '' } }
        end
        
        it 'should render the correct error message' do
          xhr :put, :update, :certificate_candidate => @attr[:certificate_candidate], :id => @certificate_candidate  
          response.body.should include("certificate.label","mandatory")
        end
      
        it 'should not create another certificate_candidate object' do
          lambda do
            xhr :put, :update, :certificate_candidate => @attr[:certificate_candidate], :id => @certificate_candidate
          end.should_not change(CertificateCandidate, :count)
        end
      end  
    end   
  end
  
  describe "DESTROY 'delete'" do
    
    describe 'for non-signed-in candidates' do
      
      it "should deny access to 'delete'" do
        delete :destroy, :id => @certificate_candidate
        response.should redirect_to signin_path
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe 'for signed-in candidates' do
      
      before :each do
        test_sign_in @candidate
      end
      
      it 'should respond http success' do
        xhr :delete, :destroy, :id => @certificate_candidate
        response.should be_success
      end
      
      it 'should respond with the correct json message' do
        xhr :delete, :destroy, :id => @certificate_candidate
        response.body.should == 'destroy!'
      end    
    
      it 'should destroy the selected certificate_candidate object' do
        lambda do
          xhr :delete, :destroy, :id => @certificate_candidate
        end.should change(CertificateCandidate, :count).by(-1)
      end   
    end    
  end
end
