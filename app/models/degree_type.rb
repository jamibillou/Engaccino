class DegreeType < ActiveRecord::Base
  
  attr_accessible :label
  
  has_many :degrees
  has_many :educations, :through => :degrees
  
  validates :label, :length => { :maximum => 30 },  :presence => true
end

# == Schema Information
#
# Table name: degree_types
#
#  id         :integer(4)      not null, primary key
#  label      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

