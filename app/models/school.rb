class School < ActiveRecord::Base
  
  attr_accessible :name, :city, :country
  
  countries_array = Country.all.collect { |c| c[0] }
  
  validates :name,    :length => { :within => 5..200 },         :presence => true
  validates :city,    :length => { :within => 2..80 },          :allow_blank => true
  validates :country, :inclusion => { :in => countries_array }, :allow_blank => true
  
end
