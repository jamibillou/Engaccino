require 'spec_helper'

describe Candidate do
  
  before(:each) do
    @attr = {
      :first_name => "Juan",
      :last_name => "Pablo",
      :city => "Madrid",         
      :country => "Spain",
      :nationality => "Spain",
      :year_of_birth => 1984,
      :phone => "+34 6 88888888",
      :email => "jp@example.net",
      :facebook_login => "jp@example.net",
      :linkedin_login => "jp@example.net",
      :twitter_login => "@j_pablo",
      :password => "pouetpouet38",
      :password_confirmation => "pouetpouet38",
      :status => 'available'
    }    
  end
    
  it "should create a new instance given valid attributes" do
    candidate = Candidate.create!(@attr)
    candidate.should be_valid
  end
  
  describe "mandatory attribues" do
       
    it "should reject candidates with a blank status" do
      candidate = Candidate.new(@attr.merge(:status => ""))
      candidate.should_not be_valid
    end
    
    it "should reject candidates with an invalid status" do
      candidate = Candidate.new(@attr.merge(:status => "Wrong status"))
      candidate.should_not be_valid
    end
  end
  
end
# == Schema Information
#
# Table name: users
#
#  id                 :integer(4)      not null, primary key
#  first_name         :string(255)
#  last_name          :string(255)
#  city               :string(255)
#  country            :string(255)
#  nationality        :string(255)
#  year_of_birth      :integer(4)
#  phone              :string(255)
#  email              :string(255)
#  facebook_login     :string(255)
#  linkedin_login     :string(255)
#  twitter_login      :string(255)
#  facebook_connect   :boolean(1)      default(FALSE)
#  linkedin_connect   :boolean(1)      default(FALSE)
#  twitter_connect    :boolean(1)      default(FALSE)
#  profile_completion :integer(4)      default(0)
#  admin              :boolean(1)      default(FALSE)
#  salt               :string(255)
#  encrypted_password :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  status             :string(255)
#

