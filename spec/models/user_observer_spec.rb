require 'spec_helper'

describe UserObserver do
  
  before(:each) do
    @not_signed_up_user = User.create :email => 'user@example.com', :password => 'password',
                                      :first_name => I18n.t('users.first_name'), :last_name => I18n.t('users.last_name'),
                                      :country => 'France', :city => I18n.t('users.city')
    @user = Factory(:user)
  end
  
  it "should increase the profile_completion by 5 after a user signs up with valid names and location" do
    profile_completion_before_update = @not_signed_up_user.profile_completion
    @not_signed_up_user.update_attributes :first_name => 'John', :last_name => 'Doe', :country => 'Netherlands', :city => 'Amsterdam'
    signed_up_user = @not_signed_up_user
    signed_up_user.profile_completion.should == profile_completion_before_update + 5
  end

end
