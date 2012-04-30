require 'spec_helper'

describe ExperiencesController do
  
  render_views

  before :each do
    @candidate  = Factory :candidate, :profile_completion => 5
    @experience = Factory :experience, :candidate => @candidate
    @attr = { :candidate_id => @candidate, :start_month => '4', :start_year => '2005', :end_month => '7', :end_year => '2005', :role => 'IT Intern', :description => 'First internship ever...',
              :company_attributes => { :name => 'Unilog', :city => 'Grenoble', :country => 'France' } }
  end

  describe "GET 'new'" do
    
    before :each do
      test_sign_in @candidate
      get :new
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
        lambda do
          xhr :post, :create, :experience => @attr.merge(:start_year => '', :company_attributes => { :name => '' })
        end.should_not change(Experience, :count)
      end
        
      it 'should fail with empty fields' do
        response.should_not be_success
      end
        
      it 'should respond with the right error message' do
        response.body.should include 'company.name', 'start_year'
      end
    end
      
    describe 'success' do
        
      before :each do
        lambda do
          xhr :post, :create, :experience => @attr
        end.should change(Experience, :count).by 1
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
      xhr :get, :edit, :id => @experience
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
        
      it 'should update the experience' do
        xhr :put, :update, :experience => @attr, :id => @experience
        updated_experience = assigns :experience
        @experience.reload
        @experience.start_month == updated_experience.start_month
        @experience.end_year    == updated_experience.end_year
        @experience.description == updated_experience.description
      end
        
      it 'should not create an experience' do
        lambda do
          xhr :put, :update, :experience => @attr, :id => @experience
        end.should_not change(Experience, :count)
      end
        
      it 'should create a company' do
        lambda do
          xhr :put, :update, :experience => @attr, :id => @experience
        end.should change(Company, :count).by 1
      end
        
      it 'should respond with the right json message' do
        xhr :put, :update, :experience => @attr, :id => @experience
        response.body.should == 'update!'
      end 
    end
      
    describe 'failure' do
        
      before :each do
        @attr = { :candidate_id => @candidate, 
                  :company_attributes => { :name => '', :city => '', :country => '' },
                  :start_month => '', :start_year => '', :end_month => '', :end_year => '',
                  :role => '', :description => '' }
      end
        
      it 'should render the right error message' do
        xhr :put, :update, :experience => @attr.merge(:start_month => '', :company_attributes => { :name => '' }), :id => @experience  
        response.body.should include 'company.name', 'start_month'
      end
    end  
  end
  
  describe "DESTROY 'delete'" do
    
    describe 'for non-signed-in users' do
      
      it "should deny access to 'delete'" do
        xhr :delete, :destroy, :id => @experience
        response.should redirect_to signin_path
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe 'for signed-in candidates' do
      
      before :each do
        test_sign_in @candidate
        lambda do
          xhr :delete, :destroy, :id => @experience
        end.should change(Experience, :count).by -1
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