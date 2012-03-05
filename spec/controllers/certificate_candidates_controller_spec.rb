require 'spec_helper'

describe CertificateCandidatesController do
  
  render_views

  before(:each) do
    @candidate = Factory(:candidate)
    @certificate_candidate = Factory(:certificate_candidate, :candidate => @candidate)
  end

  describe "GET 'new'" do
    
    describe "for non-signed-in users" do
      
      it "should deny access to 'new'" do
        get :new
        response.should redirect_to(signin_path)
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe "for signed-in users" do
      
      before(:each) do
        test_sign_in(@candidate)
      end
      
      it "should respond http success" do
        get :new
        response.should be_success
      end
      
      it "should display the correct form" do
        get :new
        response.should render_template(:partial => '_new_form')
      end
      
    end  
  end

end
