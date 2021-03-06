require 'spec_helper'

describe DegreeTypesController do
  
  before :each do
    @candidate   = Factory :candidate, :profile_completion => 5
    @degree_type = Factory :degree_type
    @attr        = { :label => 'Master'}
  end
  
  describe "PUT 'update'" do
    
    describe 'for non signed-in users' do
      
      it "should deny access to 'update'" do
        xhr :put, :update, :degree_type => @attr, :id => @degree_type
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
            xhr :put, :update, :degree_type => @attr, :id => @degree_type
          end.should_not change(DegreeType, :count)
        end
        
        it 'should update the degree_type' do
          updated_degree_type = assigns :degree_type
          @degree_type.reload
          @degree_type.label.should == updated_degree_type.label
        end
        
        it 'should respond with an empty message' do
          response.body.should == ' '
        end 
      end
      
      describe 'failure' do
        
        it 'should have the right error message' do
          xhr :put, :update, :degree_type => @attr.merge(:label => ''), :id => @degree_type 
          response.body.should include 'mandatory'
        end
      end  
    end   
  end
end