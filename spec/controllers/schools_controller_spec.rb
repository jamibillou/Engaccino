require 'spec_helper'

describe SchoolsController do
  
  before :each do
    @candidate = Factory :candidate
    @school = Factory :school
  end
  
  describe "PUT 'update'" do
    
    describe 'for non-signed-in candidates' do
      
      it "should deny access to 'update'" do
        put :update, :id => @school
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
          @attr = { :school => {:name => "Polyfarce"} }
        end
        
        it 'should update the school object ' do
          xhr :put, :update, :school => @attr[:school], :id => @school
          school = assigns :school
          @school.reload
          @school.name == school.name
        end
        
        it 'should not create a school' do
          lambda do
            xhr :put, :update, :school => @attr[:school], :id => @school
          end.should_not change(School, :count)
        end
        
        it 'should respond with an empty message (respond_with_bip return)' do
          xhr :put, :update, :school => @attr[:school], :id => @school
          response.body.should == " "
        end 
      end
      
      describe 'failure' do
        
        before :each do
          @attr = { :school => {:name => ''} }
        end
        
        it 'should render the correct error message' do
          xhr :put, :update, :school => @attr[:school], :id => @school 
          response.body.should include "mandatory"
        end
      
        it 'should not create another school object' do
          lambda do
            xhr :put, :update, :school => @attr[:school], :id => @school
          end.should_not change(School, :count)
        end
      end  
    end   
  end
end
