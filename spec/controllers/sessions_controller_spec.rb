require 'spec_helper'

describe SessionsController do

  render_views

  describe "GET 'new'" do
    
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_selector('title', :content => I18n.t('sessions.new.title'))
    end
    
  end
  
  describe "POST 'create'" do
    
    describe "invalid sign_in" do
      before(:each) do
        @attr = {:email => "test@test.fr", :password => "wrongpass"}
      end
      
      it "should re-render the new page" do
        post :create, :session => @attr
        response.should render_template('new')
      end
      
      it "should have the right title" do
        post :create, :session => @attr
        response.should have_selector('title', :content => I18n.t('sessions.new.title'))
      end
      
      it "should have a flash message" do
        post :create, :session => @attr
        response.should have_selector('div', :class => 'flash error')
      end
      
    end
    
    describe "valid sign_in" do
      before(:each) do
        @user = Factory(:user)
        @attr = {:email => @user.email, :password => @user.password}
      end
      
      it "should signed the user in" do
        post :create, :session => @attr
        controller.current_user.should == @user
        controller.should be_signed_in
      end
      
      it "should redirect to the user page" do
        post :create, :session => @attr
        response.should redirect_to(user_path(@user))
      end
    end
    
  end
  
  describe "DELETE 'destroy'" do
    
    it "should sign the user out" do
      test_sign_in(Factory(:user))
      delete :destroy
      controller.should_not be_signed_in
      response.should redirect_to(root_path)
    end
    
  end

end