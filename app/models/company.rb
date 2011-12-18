class Company < ActiveRecord::Base

  attr_accessible :name, :address, :city, :country, :phone, :email, :url
  
  has_many :experiences
  
  countries_array = Country.all.collect { |c| c[0] }
  email_regex     = /^[\w+\d\-.]+@[a-z\d\-.]+\.[a-z]{2,3}(\.[a-z]{2,3})?$/i
  phone_regex     = /^\+(?:[0-9] ?){6,14}[0-9]$/
  url_regex      = /^(http|https):\/\/((www(\d){0,3}?.)|([a-z0-9\-_]{1,63}.)+)?[a-z0-9\-_]+(.{1}[a-z]{2,4}){1,2}(\/[a-z0-9\-_]+)*$/ 
  
  validates :name,    :length => { :within => 2..80 },                                                  :presence => true
  validates :address, :length => { :within => 6..160 },                                                 :allow_blank => true
  validates :city,    :length => { :within => 2..80 },                                                  :allow_blank => true
  validates :country, :inclusion => { :in => countries_array },                                         :allow_blank => true
  validates :phone,   :length => { :within => 7..20 }, :format => { :with => phone_regex },             :allow_blank => true
  validates :email,   :format => { :with => email_regex }, :uniqueness => { :case_sensitive => false }, :allow_blank => true
  validates :url,     :format => { :with => url_regex },                                                :allow_blank => true
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

