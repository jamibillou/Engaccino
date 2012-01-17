class LanguageCandidate < ActiveRecord::Base
  
  attr_accessible :level, :language_attributes
  
  belongs_to :language
  belongs_to :candidate
  
  accepts_nested_attributes_for :language, :allow_destroy => true

  #validates_columns :level
  
end

# == Schema Information
#
# Table name: language_candidates
#
#  id           :integer(4)      not null, primary key
#  language_id  :integer(4)
#  candidate_id :integer(4)
#  level        :enum([:beginner
#  created_at   :datetime
#  updated_at   :datetime
#

