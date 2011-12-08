require 'spec_helper'

describe UserController do

  render_views

  before(:each) do
    @user = Factory(:user)
  end

  describe "GET 'index'" do
    
    describe "for non-signed-in users" do
      
      it "should deny access to 'index'" do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe "for signed-in users" do
    
      before(:each) do
        test_sign_in(@user)
      end
      
      it "should return http success" do
        get :index
        response.should be_success
      end
      
      it "should have the right title" do
        get :index
        response.should have_selector('title', :content => I18n.t('user.index.title'))
      end
      
      it "should have a card for each user" do 
        get :index
        User.all do |user|
          response.should have_selector('div', :id => "user_#{user.id}")
        end  
      end
      
      it "should have a destroy link for each user" do 
        get :index
        User.all do |user|
          response.should have_selector('div', :id => "destroy_user_#{user.id}")
        end  
      end
    end
  end

  describe "GET 'show'" do
    
    describe "for non-signed-in users" do
      
      it "should deny access to 'show'" do
        get :show, :id => @user
        response.should redirect_to(signin_path)
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe "for signed-in users" do
    
      before (:each) do
        test_sign_in(@user)
      end
      
      it "should return http success" do
        get :show, :id => @user
        response.should be_success
      end
      
      it "should have the right selected navigation tab" do
        get :show, :id => @user
        response.should have_selector('li', :class => 'round selected', :content => I18n.t(:menu_profile))
      end
    end
  end

  describe "GET 'new'" do
  
    it "should return http success" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do 
      get :new
      response.should have_selector('title', :content => I18n.t('user.new.title'))
    end
  end

  describe "POST 'create'" do
          
    it "should return http success" do
      post :create
      response.should be_success
    end
  
    describe "success" do
    
      before(:each) do
        @attr = { :first_name => "First name",
                  :last_name => "Last name",
                  :email => "new_user@example.com", 
                  :password => "pouetpouet45", 
                  :password_confirmation => "pouetpouet45" }
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end
      
      it "should render the 2nd signup form" do
        post :create, :user => @attr
        response.should render_template(:edit)
      end
      
      it "should signed the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
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
  
  describe "GET 'edit'" do
  
    describe "for non-signed-in users" do
      
      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe "for signed-in users" do
    
      before(:each) do
        test_sign_in(@user)
      end
    
      it "should return http success" do
        get :edit, :id => @user
        response.should be_success
      end
            
      it "should have the right title" do
        get :edit, :id => @user
        response.should have_selector('title', :content => I18n.t('user.edit.title'))
      end
            
      it "should have a form to edit the user profile" do
        get :edit, :id => @user
        response.should have_selector('form', :id => 'user_edit_form')
      end
    end
  end
  
  describe "PUT 'update'" do
          
    describe "for non-signed-in users" do
      
      it "should deny access to 'update'" do
        put :update, :id => @user
        response.should redirect_to(signin_path)
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe "for signed-in users" do
    
      before(:each) do
        test_sign_in(@user)
      end
      
      describe "success" do
      
        before(:each) do
          @attr = { :first_name => "Updated",
                    :last_name => "User"}
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
        
        it "should redirect to the User#show page (from the signup page)" do
          put :update, :user => @attr, :id => @user
          session[:edit_page] = :signup
          response.should redirect_to(@user)
        end
        
        it "should redirect to the User#show page (from the edit page)" do
          put :update, :user => @attr, :id => @user
          session[:edit_page] = :edit
          response.should redirect_to(@user)
        end
      end
      
      describe "failure" do
        
        before(:each) do
          @attr = { :email => "new_user@example.com",
                    :first_name => "",
                    :last_name => "",
                    :country => "" }
        end
                    
        it "should render the edit page if we come from the edit page" do
           put :update, :user => @attr, :id => @user
           session[:edit_page] = :edit
           response.should render_template(:edit)
        end
        
        it "should render the 2nd signup form if we come from the sign_up page" do
           put :update, :user => @attr, :id => @user
           session[:edit_page] = :signup
           response.should render_template(:edit)
        end 
        
        it "should not create another user" do
          lambda do
            put :update, :user => @attr, :id => @user
          end.should_not change(User, :count)
        end 
      end
    end
  end
  
  describe "authentification of edit/update actions" do
    
    describe "for non-signed-in users" do

      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
      
      it "should deny access to 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(signin_path)
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe "for signed-in users" do
      
      before(:each) {
        @wrong_user = Factory.create(:user, :email => Factory.next(:email),
                                            :facebook_login => Factory.next(:facebook_login),
                                            :linkedin_login => Factory.next(:linkedin_login),
                                            :twitter_login => Factory.next(:twitter_login),)
        test_sign_in(@wrong_user)
      }
      
      it "should require the matching user for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(user_path(@wrong_user))
        flash[:notice].should == I18n.t('flash.notice.other_user_page')
      end
      
      it "should require the matching user for 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(user_path(@wrong_user))
        flash[:notice].should == I18n.t('flash.notice.other_user_page')
      end
    end
  end

  describe "DELETE 'destroy'" do
    
    describe "for non-signed-in users" do
      
      it "should deny access to 'update'" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
        flash[:notice].should == I18n.t('flash.notice.please_signin')
      end
    end
    
    describe "for signed-in users" do
    
      before(:each) do
        test_sign_in(@user)
      end
      
      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end
      
      it "should redirect to the users page" do
        delete :destroy, :id => @user
        flash[:success].should == I18n.t('flash.success.user_destroyed')
        response.should redirect_to(users_path)
      end
    end
  end
end