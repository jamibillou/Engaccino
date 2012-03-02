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
        first_user  = User.create! :first_name => "First",   :last_name => "User",
                                   :email => "firstuser@example.com",
                                   :password => "firstUser", :password_confirmation => "firstUser",
                                   :city => "Sample city",   :country => "Netherlands"
        second_user = User.create! :first_name => "Second",   :last_name => "User",
                                   :email => "seconduser@example.com",
                                   :password => "secondUser", :password_confirmation => "secondUser",
                                   :city => "Sample city",   :country => "Netherlands"
      end
      
      describe "who haven't completed signup" do
        
        it "should deny access to 'index'" do
          get :index
          response.should redirect_to(edit_candidate_path(@user))
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

  describe "DELETE 'destroy'" do
    
    describe "for non-signed-in users" do
      
      it "should deny access to 'destroy'" do
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
          response.should redirect_to(candidate_path(@user))
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