require 'spec_helper'

describe DegreesController do

  before :each do
    @candidate = Factory :candidate
    @degree = Factory :degree
  end
  
  describe "PUT 'update'" do
    
    describe 'for non-signed-in candidates' do
      
      it "should deny access to 'update'" do
        put :update, :id => @degree
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
          @attr = { :degree => {:label => "Web Development"} }
        end
        
        it 'should update the degree object ' do
          xhr :put, :update, :degree => @attr[:degree], :id => @degree
          degree = assigns :degree
          @degree.reload
          @degree.label == degree.label
        end
        
        it 'should not create a degree' do
          lambda do
            xhr :put, :update, :degree => @attr[:degree], :id => @degree
          end.should_not change(Degree, :count)
        end
        
        it 'should respond with an empty message (respond_with_bip return)' do
          xhr :put, :update, :degree => @attr[:degree], :id => @degree
          response.body.should == " "
        end 
      end
      
      describe 'failure' do
        
        before :each do
          @attr = { :degree => {:label => ''} }
        end
        
        it 'should render the correct error message' do
          xhr :put, :update, :degree => @attr[:degree], :id => @degree 
          response.body.should include "Label can't be blank"
        end
      
        it 'should not create another degree object' do
          lambda do
            xhr :put, :update, :degree => @attr[:degree], :id => @degree
          end.should_not change(Degree, :count)
        end
      end  
    end   
  end

end
