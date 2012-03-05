class Company < ActiveRecord::Base

  attr_accessible :name, :address, :city, :country, :phone, :email, :url
  
  has_many :experiences, :dependent => :destroy
  has_many :candidates,  :through => :experiences
  has_many :recruiters
  
  countries_array = Country.all.collect { |c| c[0] }
  
  validates :name,    :length    => { :maximum => 80 },                                                    :presence => true
  validates :address, :length    => { :maximum => 160 },                                                   :allow_blank => true
  validates :city,    :length    => { :maximum =>  80 },                                                   :allow_blank => true
  validates :country, :inclusion => { :in => countries_array },                                            :allow_blank => true
  validates :phone,   :phone_format => true, :length    => { :within => 7..20 },                           :allow_blank => true
  validates :email,   :email_format => true, :uniqueness => { :case_sensitive => false },                  :allow_blank => true
  validates :url,     :url_format   => true,                                                               :allow_blank => true
  
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

