class Diploma < ActiveRecord::Base
  
  attr_accessible :label
  
  has_many :diplomaTypes
  
  validates :label, :length => { :within => 3..150 }, :presence => true
end
# == Schema Information
#
# Table name: diplomas
#
#  id         :integer(4)      not null, primary key
#  label      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

