class Education < ActiveRecord::Base
  
  attr_accessible :description, :year, :school_id, :diploma_id
  
  belongs_to :school
  belongs_to :candidate
  belongs_to :diploma
  
  validates :school_id,                                                   :presence => true
  validates :candidate_id,                                                :presence => true
  validates :diploma_id,                                                  :presence => true
  validates :description,   :length => { :within => 5..500 },             :allow_blank => true
  validates :year,          :inclusion => { :in => 1900..Time.now.year }, :allow_blank => true
  
end
# == Schema Information
#
# Table name: educations
#
#  id           :integer(4)      not null, primary key
#  school_id    :integer(4)
#  candidate_id :integer(4)
#  diploma_id   :integer(4)
#  description  :string(255)
#  year         :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

