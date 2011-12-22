class DiplomaType < ActiveRecord::Base
  
  attr_accessible :label
  
  belongs_to :diploma
  
  validates :diploma_id,                              :presence => true
  validates :label, :length => { :within => 2..30 },  :presence => true
  
end
# == Schema Information
#
# Table name: diploma_types
#
#  id         :integer(4)      not null, primary key
#  label      :string(255)
#  diploma_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

