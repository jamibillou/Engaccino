class Language < ActiveRecord::Base
  
  attr_accessible :name
  
  belongs_to :candidate
  
  validates :name, :length => { :within => 3..150 }, :presence => true
  
end
# == Schema Information
#
# Table name: languages
#
#  id           :integer(4)      not null, primary key
#  name         :string(255)
#  candidate_id :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

