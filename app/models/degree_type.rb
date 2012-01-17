class DegreeType < ActiveRecord::Base
  
  attr_accessible :label
  
  has_many :degrees, :dependent => :destroy
  has_many :educations, :through => :degrees
  
  validates :label, :length => { :within => 2..30 },  :presence => true
  
end

# == Schema Information
#
# Table name: diploma_types
#
#  id         :integer(4)      not null, primary key
#  label      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

