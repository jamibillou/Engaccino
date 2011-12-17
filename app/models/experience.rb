class Experience < ActiveRecord::Base

  attr_accessible :role, :start_month, :start_year, :end_month, :end_year, :description
  
  belongs_to :candidate
  
  validates :candidate_id,                                              :presence => true
  validates :role,        :length => { :within => 3..80 },              :presence => true
  validates :start_year,  :inclusion => { :in => 1900..Time.now.year }, :presence => true
  validates :end_year,    :inclusion => { :in => 1900..Time.now.year }, :presence => true
  validates :start_month, :inclusion => { :in => 1..12 },               :allow_blank => true
  validates :end_month,   :inclusion => { :in => 1..12 },               :allow_blank => true
  validates :description, :length => { :within => 20..160 },            :allow_blank => true
end

# == Schema Information
#
# Table name: experiences
#
#  id           :integer(4)      not null, primary key
#  candidate_id :integer(4)
#  company_id   :integer(4)
#  start_month  :integer(4)
#  start_year   :integer(4)
#  end_month    :integer(4)
#  end_year     :integer(4)
#  description  :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  role         :string(255)
#

