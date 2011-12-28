class School < ActiveRecord::Base
  
  attr_accessible :name, :city, :country
  
  has_and_belongs_to_many :degrees
  has_many :educations, :dependent => :destroy
  has_many :candidates, :through => :educations
  
  countries_array = Country.all.collect { |c| c[0] }
  
  validates :name,    :length => { :within => 5..200 },         :presence => true
  validates :city,    :length => { :within => 2..80 },          :allow_blank => true
  validates :country, :inclusion => { :in => countries_array }, :allow_blank => true
  
end
# == Schema Information
#
# Table name: schools
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  city       :string(255)
#  country    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

