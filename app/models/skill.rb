class Skill < ActiveRecord::Base

  attr_accessible :label
  
  validates :label, :length => { :within => 1..100 },  :presence => true
  
end

# == Schema Information
#
# Table name: skills
#
#  id         :integer(4)      not null, primary key
#  label      :string(255)
#  type       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

