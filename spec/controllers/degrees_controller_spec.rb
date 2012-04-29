require 'spec_helper'

describe DegreesController do

  before :each do
    @candidate = Factory :candidate, :profile_completion => 5
    @degree    = Factory :degree
    @attr      = { :label => "Web Development" }
  end
  
  describe "PUT 'update'" do
    
    describe 'for non-signed-in candidates' do
      
      it "should deny access to 'update'" do
        xhr :put, :update, :degree => @attr, :id => @degree
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
          lambda do
            xhr :put, :update, :degree => @attr, :id => @degree
          end.should_not change(Degree, :count)
        end
        
        it 'should update the degree object' do
          updated_degree = assigns :degree
          @degree.reload
          @degree.label.should == updated_degree.label
        end
        
        it 'should respond with an empty message' do
          response.body.should == ' '
        end 
      end
      
      describe 'failure' do
        
        it 'should have the right error message' do
          xhr :put, :update, :degree => @attr.merge(:label => ''), :id => @degree 
          response.body.should include "mandatory"
        end
      end  
    end   
  end
end