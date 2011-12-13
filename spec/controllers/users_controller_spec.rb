require 'spec_helper'

describe UsersController do

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
        first_user = User.create!(:first_name              => "First",
                                  :last_name               => "User",
                                  :email                   => "firstuser@example.com",
                                  :password                => "firstUser",
                                  :password_confirmation   => "firstUser")
        second_user = User.create!(:first_name             => "Second",
                                   :last_name              => "User",
                                   :email                  => "seconduser@example.com",
                                   :password               => "secondUser",
                                   :password_confirmation  => "secondUser")
      end
      
      describe "who haven't completed signup" do
        
        it "should deny access to 'index'" do
          get :index
          response.should redirect_to(edit_user_path(@user))
          flash[:notice].should == I18n.t('flash.notice.please_finish_signup')
        end
      end
      
      describe "who have completed signup" do
      
        before(:each) do
          @user.update_attributes(:profile_completion => 10)
        end
        
        it "should return http success" do
          get :index
          response.should be_success
        end
        
        it "should have the right title" do
          get :index
          response.should have_selector('title', :content => I18n.t('users.index.title'))
        end
        
        it "should have the right selected navigation tab" do
          get :index
          response.should have_selector('li', :class => 'round selected', :content => I18n.t(:menu_users))
        end
        
        it "should have a card for each user" do 
          get :index
          User.all.each do |user|
            response.should have_selector('div', :id => "user_#{user.id}")
          end  
        end
        
        describe "for admin users" do
          
          before(:each) do
            @user.toggle!(:admin)
          end
          
          it "should have a destroy link for each user" do 
            get :index            
            User.all.each do |user|
              response.should have_selector('a', :id => "destroy_user_#{user.id}")
            end
          end            
        end
        
        describe "for non-admin users" do
          it "shouldn't have a destroy link for each user" do 
            get :index
            User.all.each do |user|
              response.should_not have_selector('a', :id => "destroy_user_#{user.id}")
            end
          end  
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
      
      describe "who haven't completed signup" do
        
        it "should deny access to 'show'" do
          get :show,  :id => @user
          response.should redirect_to(edit_user_path(@user))
          flash[:notice].should == I18n.t('flash.notice.please_finish_signup')
        end
      end
      
      describe "who have completed signup" do
        
        before(:each) do
          @user.update_attributes(:profile_completion => 10)
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
  end

  describe "GET 'new'" do
  
    describe "for signed-in users" do
      
      it "should deny access to 'new'" do
        test_sign_in(@user)
        get :new
        response.should redirect_to(user_path(@user))
        flash[:notice].should == I18n.t('flash.notice.already_registered')
      end
    end
    
    describe "for non-signed-in users" do
    
      it "should return http success" do
        get :new
        response.should be_success
      end
      
      it "should have the right title" do 
        get :new
        response.should have_selector('title', :content => I18n.t('users.new.title'))
      end
    end
  end

  describe "POST 'create'" do
          
    describe "for signed-in users" do
      
      it "should deny access to 'create'" do
        test_sign_in(@user)
        post :create
        response.should redirect_to(user_path(@user))
        flash[:notice].should == I18n.t('flash.notice.already_registered')
      end
    end
    
    describe "for non-signed-in users" do
    
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
    
      before (:each) do
        test_sign_in(@user)
      end
    
      it "should return http success" do
        get :edit, :id => @user
        response.should be_success
      end
            
      describe "edit page" do
      
        before(:each) do
          @user.update_attributes(:profile_completion => 10)
        end
        
        it "should have the right title" do
          get :edit, :id => @user
          response.should have_selector('title', :content => I18n.t('users.edit.title'))
        end
        
        it "should have the right selected navigation tab" do
          get :edit, :id => @user
          response.should have_selector('li', :class => 'round selected', :content => I18n.t(:menu_edit))
        end
              
        it "should have an edit form" do
          get :edit, :id => @user
          response.should have_selector('form', :id => 'user_edit_form')
        end
      end
      
      describe "signup page" do
      
        before(:each) do
          @user.update_attributes(:profile_completion => 0)
        end
        
        it "should have the right title" do
          get :edit, :id => @user
          response.should have_selector('title', :content => I18n.t('users.edit.complete_your_profile'))
        end
              
        it "should have a signup form" do
          get :edit, :id => @user
          response.should have_selector('form', :id => 'user_signup_form')
        end
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
          @user.profile_completion >= 0
        end
        
        it "should not create a user" do
          lambda do
            put :update, :user => @attr, :id => @user
          end.should_not change(User, :count)
        end
        
        it "should redirect to the User#show page" do
          put :update, :user => @attr, :id => @user
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
      
      describe "who haven't got admin rights" do
      
        it "should not destroy the user" do
          lambda do
            delete :destroy, :id => @user
          end.should_not change(User, :count).by(-1)
        end
        
        it "should redirect to the root path" do
          delete :destroy, :id => @user
          flash[:notice].should == I18n.t('flash.notice.restricted_page')
          response.should redirect_to(user_path(@user))
        end
      end
      
      describe "who have admin rights" do
      
        before(:each) do
          @user.toggle!(:admin)
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
end