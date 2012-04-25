require 'spec_helper'

describe EducationsController do
  render_views

  before :each do
    @candidate = Factory :candidate
    @education = Factory :education, :candidate => @candidate
  end

  describe "GET 'new'" do
          
    before :each do
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
                    :degree_attributes => { :degree_type_attributes => { :label => '' }, :label => '' },
                    :school_attributes => { :name => '' },
                    :start_month => '', :start_year => '', :end_month => '', :end_year => '',
                    :description => '' }
        end
        
        it 'should fail with empty fields' do
          xhr :post, :create, :education => @attr
          response.should_not be_success
        end
        
        it 'should respond with the error messages' do
          xhr :post, :create, :education => @attr
          response.body.should include('school.name','degree.degree_type.label','degree.label','start_month','end_month',
            'start_year','end_year',"mandatory")
        end
      end
      
      describe 'success' do
        
        before :each do
          @attr = { :candidate_id => @candidate, 
            :degree_attributes => { :degree_type_attributes => { :label => 'Bachelor' }, :label => 'Biology' },
            :school_attributes => { :name => 'Universidad de Barcelona' },
            :start_month => '9', :start_year => '2000', :end_month => '9', :end_year => '2003',
            :description => 'Great studies, I learnt a lot of worthy knowledges.' }
        end
        
        it 'should respond http success' do
          xhr :post, :create, :education => @attr
          response.should be_success
        end
        
        it 'should respond with the correct json message' do
          xhr :post, :create, :education => @attr
          response.body.should == 'create!'
        end    
      
        it 'should create a education object' do
          lambda do
            xhr :post, :create, :education => @attr
          end.should change(Education, :count).by(1)
        end
      end      
    end    
  end
  
  describe "GET 'edit'" do
      
    before :each do
      test_sign_in @candidate
    end
              
    # it 'should respond http success' do
    #   xhr :get, :edit, :id => @education
    #   response.should be_success
    # end
    # 
    # it 'should display the correct form' do
    #   xhr :get, :edit, :id => @education
    #   response.should render_template(:partial => '_edit_form')
    # end
  end
  
  describe "PUT 'update'" do
    
    describe 'for non-signed-in candidates' do
      
      it "should deny access to 'update'" do
        put :update, :id => @education
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
          @attr = { :education => { :candidate_id => @candidate, 
            :degree_attributes => { :degree_type_attributes => { :label => 'Bachelor' }, :label => 'Biology' },
            :school_attributes => { :name => 'Universidad de Barcelona' },
            :start_month => '9', :start_year => '2000', :end_month => '9', :end_year => '2003',
            :description => 'Great studies, I learnt a lot of worthy knowledges.' } }
        end
        
        it 'should update the education object ' do
          xhr :put, :update, :education => @attr[:education], :id => @education
          education = assigns :education
          @education.reload
          @education.start_month == education.start_month
          @education.end_month == education.end_month
          @education.start_year == education.start_year
          @education.end_year == education.end_year
          @education.description == education.description
        end
        
        it 'should not create a education' do
          lambda do
            xhr :put, :update, :education => @attr[:education], :id => @education
          end.should_not change(Education, :count)
        end
        
        it 'should create a degree' do
          lambda do
            xhr :put, :update, :education => @attr[:education], :id => @education
          end.should change(Degree, :count).by(1)
        end
        
        it 'should create a degree_type' do
          lambda do
            xhr :put, :update, :education => @attr[:education], :id => @education
          end.should change(DegreeType, :count).by(1)
        end
        
        it 'should create a school' do
          lambda do
            xhr :put, :update, :education => @attr[:education], :id => @education
          end.should change(School, :count).by(1)
        end
        
        it 'should respond with the correct json message' do
          xhr :put, :update, :education => @attr[:education], :id => @education
          response.body.should == 'update!'
        end 
      end
      
      describe 'failure' do
        
        before :each do
          @attr = { :education => { :candidate_id => @candidate, 
            :degree_attributes => { :degree_type_attributes => { :label => '' }, :label => '' },
            :school_attributes => { :name => '' },
            :start_month => '', :start_year => '', :end_month => '', :end_year => '',
            :description => '' } }
        end
        
        it 'should render the correct error message' do
          xhr :put, :update, :education => @attr[:education], :id => @education  
          response.body.should include('school.name','degree.degree_type.label','degree.label','start_month','end_month',
            'start_year','end_year',"mandatory")
        end
      
        it 'should not create another education object' do
          lambda do
            xhr :put, :update, :education => @attr[:education], :id => @education
          end.should_not change(Education, :count)
        end
      end  
    end   
  end
  
  describe "DESTROY 'delete'" do
    
    describe 'for non-signed-in candidates' do
      
      it "should deny access to 'delete'" do
        delete :destroy, :id => @education
        response.should redirect_to signin_path
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe 'for signed-in candidates' do
      
      before :each do
        test_sign_in @candidate
      end
      
      it 'should respond http success' do
        xhr :delete, :destroy, :id => @education
        response.should be_success
      end
      
      it 'should respond with the correct json message' do
        xhr :delete, :destroy, :id => @education
        response.body.should == 'destroy!'
      end    
    
      it 'should destroy the selected education object' do
        lambda do
          xhr :delete, :destroy, :id => @education
        end.should change(Education, :count).by(-1)
      end   
    end    
  end
end
