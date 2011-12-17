class Company < ActiveRecord::Base

  attr_accessible :name, :address, :city, :country, :phone, :email, :url

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

