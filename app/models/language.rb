class Language < ActiveRecord::Base
  
  attr_accessible :label
  
  has_many :language_candidates, :dependent => :destroy
  has_many :candidates, :through => :language_candidates
  
  validates :label, :length => { :maximum => 80 }, :presence => true
  
end

# == Schema Information
#
# Table name: languages
#
#  id         :integer(4)      not null, primary key
#  label      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

