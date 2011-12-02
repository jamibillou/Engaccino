require 'spec_helper'

describe UserController do

  render_views

  before(:each) do
    @user = Factory(:user)
  end

  describe "GET 'index'" do
    it "returns http success" do
      get :index
      response.should be_success
    end
  end

  describe "GET 'show'" do
    
    it "returns http success" do
      get :show, :id => @user
      response.should be_success
    end
  end

  describe "GET 'new'" do
  
    it "returns http success" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do 
      get :new
      response.should have_selector('title', :content => I18n.t('user.new.title'))
    end
    
  end

  describe "POST 'create'" do
          
    it "returns http success" do
      post :create
      response.should be_success
    end
  
    describe "success" do
    
      before(:each) do
        @attr = { 
                  :email => "new_user@example.com", 
                  :password => "pouetpouet45", 
                  :password_confirmation => "pouetpouet45" 
                 }
      end
    
      it "should render the 2nd signup form" do
        post :create, :user => @attr
        response.should render_template(:signup_step_2)
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end
      
    end
    
    describe "failure" do
      
      it "should render the 'new' template" do
        post :create, :email => "", :password => "", :password_confirmation => ""
        response.should render_template(:new)
      end
      
      it "should have a flash message" do
        post :create, :email => "", :password => "", :password_confirmation => ""
        response.should have_selector('div', :class => 'flash error')
      end
    end    
  end
  
  describe "PUT 'update'" do
          
    it "returns http success" do
      put :update, :id => @user
    response.should be_success
    end
    
    describe "success" do
    
      before(:each) do
        @attr = { 
                  :first_name => "New",
                  :last_name => "User",
                  :country => "NL",
                  :year_of_birth => 27.years.ago.year
                }
      end
    
      it "should redirect to the User#show page" do
        put :update, :user => @attr, :id => @user
        response.should redirect_to(user_path)
      end
      
      it "should update the user's attributes" do
        put :update, :user => @attr, :id => @user
        user = assigns(:user)
        @user.reload
        @user.first_name == user.first_name
        @user.last_name == user.last_name
        @user.country == user.country
        @user.year_of_birth == user.year_of_birth
      end
      
      it "should not create a user" do
        lambda do
          put :update, :user => @attr, :id => @user
        end.should_not change(User, :count)
      end

    end
    
    describe "failure" do
      
      before(:each) do
        @attr = { 
                  :email => "new_user@example.com",
                  :first_name => "",
                  :last_name => "",
                  :country => ""
                }
      end
                  
      it "should render to the 2nd signup form" do
         put :update, :user => @attr, :id => @user
         response.should render_template(:signup_step_2)
      end 
      
      it "should not create another user" do
        lambda do
          put :update, :user => @attr, :id => @user
        end.should_not change(User, :count)
      end 
    end
  end

  describe "GET 'edit'" do
  
    it "returns http success" do
      get :edit, :id => @user
      response.should be_success
    end
          
    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector('title', :content => I18n.t('user.edit.title'))
    end
          
    it "should have a form to edit the user profile" do
      get :edit, :id => @user
      response.should have_selector('form', :id => 'edit_form')
    end
  end

  describe "PUT 'update'" do
  
    describe "failure" do
    
      before(:each) do
        @attr = { :first_name => "",
                  :last_name => "",
                  :country => ""
                }
      end
      
      it "should render the edit page" do
        put :update, :id => @user, :user => @attr
        response.should render_template(:edit)
      end
    end
    
    describe "success" do
      
      before(:each) do
        @attr = { :first_name => "New first name",
                  :last_name => "New last name",
                  :country => "FR",
                  :year_of_birth => "1978",
                  :password => "pouetpouet"
                }
      end
      
      it "should change the User's attributes" do
        put :update, :id => @user,  :user => @attr
        user = assigns(:user)
        @user.reload
        @user.first_name.should == user.first_name
        @user.last_name.should == user.last_name
        @user.country.should == user.country
      end
      
      it "should have a flash message" do
        put :update, :id => @user, :user => @attr
        response.should have_selector('div', :class => 'flash success')
      end
    end
  end

  describe "DELETE 'destroy'" do
    
    it "returns http success" do
      delete :destroy, :id => @user
      response.should be_success
    end
  end
end