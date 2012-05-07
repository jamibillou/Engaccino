class Certificate < ActiveRecord::Base
  
  attr_accessible :label
  
  validates :label, :length => { :maximum => 100 },  :presence => true
end

# == Schema Information
#
# Table name: certificates
#
#  id         :integer(4)      not null, primary key
#  label      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

