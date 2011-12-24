class Diploma < ActiveRecord::Base
  
  attr_accessible :label
  
  has_many :diplomaTypes
  has_many :educations, :dependent => :destroy
  has_many :candidates, :through => :educations
  
  validates :label, :length => { :within => 3..150 }, :presence => true
  
  accepts_nested_attributes_for :diplomaTypes, :reject_if => lambda { |attr| attr[:content].blank? }, :allow_destroy => true
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

