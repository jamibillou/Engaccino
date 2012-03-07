require 'spec_helper'

describe DegreeTypesController do
  
  before :each do
    @candidate = Factory :candidate
    @degree_type = Factory :degree_type
  end
  
  describe "PUT 'update'" do
    
    describe 'for non-signed-in candidates' do
      
      it "should deny access to 'update'" do
        put :update, :id => @degree_type
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
          @attr = { :degree_type => {:label => "Master"} }
        end
        
        it 'should update the degree_type object ' do
          xhr :put, :update, :degree_type => @attr[:degree_type], :id => @degree_type
          degree_type = assigns :degree_type
          @degree_type.reload
          @degree_type.label == degree_type.label
        end
        
        it 'should not create a degree_type' do
          lambda do
            xhr :put, :update, :degree_type => @attr[:degree_type], :id => @degree_type
          end.should_not change(DegreeType, :count)
        end
        
        it 'should respond with an empty message (respond_with_bip return)' do
          xhr :put, :update, :degree_type => @attr[:degree_type], :id => @degree_type
          response.body.should == " "
        end 
      end
      
      describe 'failure' do
        
        before :each do
          @attr = { :degree_type => {:label => ""} }
        end
        
        it 'should render the correct error message' do
          xhr :put, :update, :degree_type => @attr[:degree_type], :id => @degree_type 
          response.body.should include "Label can't be blank"
        end
      
        it 'should not create another degree_type object' do
          lambda do
            xhr :put, :update, :degree_type => @attr[:degree_type], :id => @degree_type
          end.should_not change(DegreeType, :count)
        end
      end  
    end   
  end

end
