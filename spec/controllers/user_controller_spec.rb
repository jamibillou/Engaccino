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
    
    describe "Form submission part 1" do
      
      it "returns http success" do
        post :create
        response.should be_success
      end
    
      describe "success" do
        before(:each) do
          @attr = { :email => "new_user@example.com",
                    :password => "pouetpouet45",
                    :password_confirmation => "pouetpouet45"
                  }
        end
        
        it "should have render the 2nd part of the form" do
          post :create, :user => @attr
          response.should render_template(:create)
        end
        
        it "should have the right h2 title" do
          post :create, :user => @attr
          response.should have_selector('h2', :content => I18n.t('user.new.personal_information'))
        end
      end
      
      describe "failure" do
        before(:each) do
          @attr = { :email => "",
                    :password => "",
                    :password_confirmation => ""
                  }
        end
        
        it "should have render the 'new' page" do
          post :create, :user => @attr
          response.should render_template(:new)
        end
        
        it "should have the right h2 title" do
          post :create, :user => @attr
          response.should have_selector('h2', :content => I18n.t('user.new.create_engaccino_account'))
        end
      end
      
    end
    
    describe "Form submission part 2" do
      
      before(:each) do
        @user_attr = {:email => "new_user@example.com",
                         :password => "pouetpouet45",
                         :password_confirmation => "pouetpouet45"} 
        session[:new_user] = User.new(@user_attr)
      end
      
      describe "success" do
        before(:each) do
          @attr = { :first_name => "New",
                    :last_name => "User",
                    :country => "NL",
                    :birthdate => 27.years.ago }
        end
        
        it "should create a user" do
         lambda do
            post :create2, :user => @attr
          end.should change(User, :count).by(1)
        end
      
        it "should redirect to the User#show page" do
          post :create2, :user => @attr
          response.should redirect_to(user_path(assigns(:user)))
        end
      end
      
      describe "failure" do
        @attr = { :first_name => "",
                  :last_name => "",
                  :country => ""}
        
                    
        it "should render to the create page" do
           post :create2, :user => @attr
           response.should render_template(:create)
        end  
         
        it "should have the right h2 title" do
          post :create2, :user => @attr
          response.should have_selector('h2', :content => I18n.t('user.new.personal_information'))
        end
        
        it "should not create a user" do
          lambda do
            post :create2, :user => @attr
          end.should_not change(User, :count)
        end
      end
    end
#      it "should have a welcome message" do
#        post :create, :user => @attr
#        flash[:success].should =~ /welcome to the sample app/i
#      end
#      
#      it "should sign user in" do
#        post :create, :user => @attr
#        controller.should be_signed_in
#      end
  end

  describe "GET 'edit'" do
  
    it "returns http success" do
      get :edit, :id => @user
      response.should be_success
    end
  end

  describe "PUT 'update'" do
  
    it "returns http success" do
      put :update, :id => @user
      response.should be_success
    end
  end

  describe "DELETE 'destroy'" do
    
    it "returns http success" do
      delete :destroy, :id => @user
      response.should be_success
    end
  end
end