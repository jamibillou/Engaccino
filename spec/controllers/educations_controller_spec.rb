require 'spec_helper'

describe EducationsController do
  
  render_views

  before :each do
    @candidate = Factory :candidate, :profile_completion => 5
    @education = Factory :education, :candidate => @candidate
    @attr = { :candidate_id => @candidate, :start_month => '9', :start_year => '2000', :end_month => '9', :end_year => '2003', :description => 'Great studies, I learnt a lot.',
              :degree_attributes => { :degree_type_attributes => { :label => 'Bachelor' }, :label => 'Biology' }, :school_attributes => { :name => 'Universidad de Barcelona' } }
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
          xhr :post, :create, :education => @attr.merge(:start_month => '', :school_attributes => { :name => '' })
        end.should_not change(Education, :count)
      end
        
      it 'should fail with empty fields' do
        response.should_not be_success
      end
        
      it 'should respond with the right error message' do
        response.body.should include 'school.name', 'start_month'
      end
    end
      
    describe 'success' do
        
      before :each do
        lambda do
          xhr :post, :create, :education => @attr
        end.should change(Education, :count).by 1
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
      xhr :get, :edit, :id => @education
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

      it 'should update the education' do
        xhr :put, :update, :education => @attr, :id => @education
        updated_education = assigns :education
        @education.reload
        @education.start_month.should == updated_education.start_month
        @education.end_year.should    == updated_education.end_year
        @education.description.should == updated_education.description
      end
        
      it 'should not create an education' do
        lambda do
          xhr :put, :update, :education => @attr, :id => @education
        end.should_not change(Education, :count)
      end
        
      it 'should create a degree, degree_type, and school' do
        lambda do
          xhr :put, :update, :education => @attr, :id => @education
        end.should change(Degree, :count).by(1) && change(DegreeType, :count).by(1) && change(School, :count).by(1)
      end
        
      it 'should respond with the right json message' do
        xhr :put, :update, :education => @attr, :id => @education
        response.body.should == 'update!'
      end 
    end
      
    describe 'failure' do

      it 'should render the right error message' do
        xhr :put, :update, :education => @attr.merge(:start_month => '', :school_attributes => { :name => '' }), :id => @education  
        response.body.should include 'school.name', 'start_month'
      end
    end  
  end
  
  describe "DESTROY 'delete'" do
    
    describe 'for non-signed-in users' do
      
      it "should deny access to 'delete'" do
        xhr :delete, :destroy, :id => @education
        response.should redirect_to signin_path
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe 'for signed-in candidates' do
      
      before :each do
        test_sign_in @candidate
        lambda do
          xhr :delete, :destroy, :id => @education
        end.should change(Education, :count).by -1
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