require 'spec_helper'

describe Company do

  before(:each) do
    @attr = { :name => 'Engaccino',
              :address => 'Currently unkown',
              :city => 'Rotterdam',
              :country => 'Netherlands (The)',
              :phone => '+31 6 00000000',
              :email => 'info@engaccino.com',
              :url => 'http://www.engaccino.com'
            }  
  end
  
  it "should create a new instance given valid attributes" do
    company = Company.create!(@attr)
    company.should be_valid
  end
end



# == Schema Information
#
# Table name: companies
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  address    :string(255)
#  city       :string(255)
#  country    :string(255)
#  phone      :string(255)
#  email      :string(255)
#  url        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

