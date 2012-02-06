class Skill < ActiveRecord::Base

  attr_accessible :label
  
  has_many :skill_candidates, :dependent => :destroy
  has_many :candidates, :through => :skill_candidates
  
  label_regex = /^[a-zA-Z ]*$/ix
  
  validates :label, :format => { :with => label_regex }, :length => { :within => 2..100 },  :presence => true
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

