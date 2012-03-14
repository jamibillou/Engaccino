require 'spec_helper'

describe ExperiencesController do
  render_views

  before :each do
    @candidate = Factory :candidate
    @experience = Factory :experience, :candidate => @candidate
  end

  describe "GET 'new'" do
    
    describe 'for non-signed-in candidates' do
      
      it "should deny access to 'new'" do
        get :new
        response.should redirect_to signin_path
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe 'for signed-in candidates' do
      
      before(:each) do
        test_sign_in @candidate
      end
      
      it 'should respond http success' do
        get :new
        response.should be_success
      end
    
      it 'should display the correct form' do
        get :new
        response.should render_template(:partial => '_new_form')
      end  
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
          @attr = { :candidate_id => @candidate, 
                    :company_attributes => { :name => '', :city => '', :country => '' },
                    :start_month => '', :start_year => '', :end_month => '', :end_year => '',
                    :role => '', :description => '' }
        end
        
        it 'should fail with empty fields' do
          xhr :post, :create, :experience => @attr
          response.should_not be_success
        end
        
        it 'should respond with the error messages' do
          xhr :post, :create, :experience => @attr
          response.body.should include('company.name','role','start_month','end_month','start_year','end_year',"can't be blank")
        end
      end
      
      describe 'success' do
        
        before :each do
          @attr = { :candidate_id => @candidate, 
            :company_attributes => { :name => 'Unilog' },
            :start_month => '4', :start_year => '2005', :end_month => '7', :end_year => '2005',
            :role => 'IT Trainee', :description => 'First training period, such a long time...' }
        end
        
        #it 'should respond http success' do
        #  xhr :post, :create, :experience => @attr
        #  response.should be_success
        #end
        
        #it 'should respond with the correct json message' do
        #  xhr :post, :create, :experience => @attr
        #  response.body.should == 'create!'
        #end    
      
        #it 'should create an experience object' do
        #  lambda do
        #    xhr :post, :create, :experience => @attr
        #  end.should change(Experience, :count).by(1)
        #end
      end      
    end    
  end
  
  describe "GET 'edit'" do
    
    describe 'for non-signed-in candidates' do
      
      it "should deny access to 'edit'" do
        get :edit
        response.should redirect_to signin_path
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe 'for signed-in candidates' do
      
      before(:each) do
        test_sign_in @candidate
      end
      
      describe 'failure' do
        
        it 'should fail using the html format' do
          get :edit, :id => @experience
          response.should redirect_to @candidate
          flash[:notice].should == I18n.t('flash.notice.restricted_page')
        end
      end
      
      describe 'success' do
        it 'should respond http success' do
          xhr :get, :edit, :id => @experience
          response.should be_success
        end
      
        it 'should display the correct form' do
          xhr :get, :edit, :id => @experience
          response.should render_template(:partial => '_edit_form')
        end
      end      
    end  
  end
  
  describe "PUT 'update'" do
    
    describe 'for non-signed-in candidates' do
      
      it "should deny access to 'update'" do
        put :update, :id => @experience
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
          @attr = { :experience => { :candidate_id => @candidate, 
            :company_attributes => { :name => 'Unilog', :city => 'Grenoble', :country => 'France' },
            :start_month => '4', :start_year => '2005', :end_month => '7', :end_year => '2005',
            :role => 'IT Trainee',:description => 'First training period, such a long time...' } }
        end
        
        it 'should update the experience object ' do
          xhr :put, :update, :experience => @attr[:experience], :id => @experience
          experience = assigns :experience
          @experience.reload
          @experience.start_month == experience.start_month
          @experience.end_month == experience.end_month
          @experience.start_year == experience.start_year
          @experience.end_year == experience.end_year
          @experience.description == experience.description
        end
        
        it 'should not create an experience' do
          lambda do
            xhr :put, :update, :experience => @attr[:experience], :id => @experience
          end.should_not change(Experience, :count)
        end
        
        it 'should create a company' do
          lambda do
            xhr :put, :update, :experience => @attr[:experience], :id => @experience
          end.should change(Company, :count).by(1)
        end
        
        it 'should respond with the correct json message' do
          xhr :put, :update, :experience => @attr[:experience], :id => @experience
          response.body.should == 'update!'
        end 
      end
      
      describe 'failure' do
        
        before :each do
          @attr = { :experience => { :candidate_id => @candidate, 
                    :company_attributes => { :name => '', :city => '', :country => '' },
                    :start_month => '', :start_year => '', :end_month => '', :end_year => '',
                    :role => '', :description => '' } }
        end
        
        it 'should render the correct error message' do
          xhr :put, :update, :experience => @attr[:experience], :id => @experience  
          response.body.should include('company.name','role','start_month','end_month','start_year','end_year',"can't be blank")
        end
      
        it 'should not create another experience object' do
          lambda do
            xhr :put, :update, :experience => @attr[:experience], :id => @experience
          end.should_not change(Experience, :count)
        end
      end  
    end   
  end
  
  describe "DESTROY 'delete'" do
    
    describe 'for non-signed-in candidates' do
      
      it "should deny access to 'delete'" do
        delete :destroy, :id => @experience
        response.should redirect_to signin_path
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe 'for signed-in candidates' do
      
      before :each do
        test_sign_in @candidate
      end
      
      it 'should respond http success' do
        xhr :delete, :destroy, :id => @experience
        response.should be_success
      end
      
      it 'should respond with the correct json message' do
        xhr :delete, :destroy, :id => @experience
        response.body.should == 'destroy!'
      end    
    
      it 'should destroy the selected experience object' do
        lambda do
          xhr :delete, :destroy, :id => @experience
        end.should change(Experience, :count).by(-1)
      end   
    end    
  end
end
