class Degree < ActiveRecord::Base
  
  attr_accessible :label
  
  belongs_to :degree_type
  
  has_and_belongs_to_many :schools
  has_many :educations, :dependent => :destroy
  has_many :candidates, :through => :educations
  
  validates :degree_type_id,                          :presence => true
  validates :label, :length => { :within => 3..150 }, :presence => true
    
end
# == Schema Information
#
# Table name: degrees
#
#  id             :integer(4)      not null, primary key
#  label          :string(255)
#  degree_type_id :integer(4)
#  created_at     :datetime
#  updated_at     :datetime
#

