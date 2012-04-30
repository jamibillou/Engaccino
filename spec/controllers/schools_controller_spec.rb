require 'spec_helper'

describe SchoolsController do
  
  before :each do
    @candidate = Factory :candidate
    @school    = Factory :school
    @attr      = { :name => 'Polyfarce' }
  end
  
  describe "PUT 'update'" do
    
    describe 'for non-signed-in user' do
      
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
          lambda do
            xhr :put, :update, :school => @attr, :id => @school
          end.should_not change(School, :count)
        end
        
        it 'should update the school' do
          updated_school = assigns :school
          @school.reload
          @school.name.should == updated_school.name
        end
        
        it 'should respond with an empty message' do
          response.body.should == ' '
        end 
      end
      
      describe 'failure' do
        
        it 'should render the right error message' do
          xhr :put, :update, :school => @attr.merge(:name => ''), :id => @school 
          response.body.should include 'mandatory'
        end
      end  
    end   
  end
end