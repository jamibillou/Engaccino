class Experience < ActiveRecord::Base

  attr_accessible :role, :start_month, :start_year, :end_month, :end_year, :description, :company_attributes
  
  belongs_to :candidate
  belongs_to :company
  
  accepts_nested_attributes_for :company, :allow_destroy => true
            
  validates :candidate_id,                                              :presence => true
  validates :company,                                                   :presence => true
  validates :role,        :length    => { :within => 3..80 },           :presence => true
  validates :start_year,  :inclusion => { :in => 1900..Time.now.year }, :presence => true
  validates :end_year,    :inclusion => { :in => 1900..Time.now.year }, :presence => true
  validates :start_month, :inclusion => { :in => 1..12 },               :allow_blank => true
  validates :end_month,   :inclusion => { :in => 1..12 },               :allow_blank => true
  validates :description, :length    => { :within => 20..160 },         :allow_blank => true
    
  def duration
    end_year - start_year - 1 + (12 - start_month + end_month) / 12.0
  end
  
  def years_before_latest_experience
    self == candidate.latest_experience ? 0 : candidate.latest_experience.end_year - end_year - 1 + (12 - end_month + candidate.latest_experience.end_month) / 12.0
  end
  
  def years_after_first_event
    self == candidate.first_event ? 0 : start_year - candidate.first_event.start_year - 1 + (12 - candidate.first_event.start_month + start_month) / 12.0
  end
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

