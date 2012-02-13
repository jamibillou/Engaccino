class Experience < ActiveRecord::Base

  attr_accessible :role, :start_month, :start_year, :end_month, :end_year, :description, :company_attributes, :company, :current
  
  belongs_to :candidate
  belongs_to :company
  
  accepts_nested_attributes_for :company, :allow_destroy => true
            
  validates :candidate_id,                                              :presence => true
  validates :company,                                                   :presence => true
  validates :role,        :length    => { :within => 3..80 },           :presence => true
  validates :start_month, :inclusion => { :in => 1..12 },               :presence => true
  validates :start_year,  :inclusion => { :in => 1900..Time.now.year }, :presence => true
  validates :end_month,   :inclusion => { :in => 1..12 },               :presence => true, :unless => :current
  validates :end_year,    :inclusion => { :in => 1900..Time.now.year }, :presence => true, :unless => :current
  validate  :date_consistance,                                                             :unless => :current
  validates :description, :length    => { :within => 20..300 },         :allow_blank => true
  
  def duration
    start_year.nil? || end_year.nil? || start_month.nil? || end_month.nil? ? nil : end_year - start_year - 1 + (13 - start_month + end_month) / 12.0
  end
  
  def yrs_after_first_event
    if start_year.nil? || end_year.nil? || start_month.nil? || end_month.nil?
      nil
    else
      self == candidate.first_event ? 0 : start_year - candidate.first_event.start_year - 1 + (12 - candidate.first_event.start_month + start_month) / 12.0
    end
  end
  
  private
    
    def date_consistance
      errors.add(:duration, I18n.t('experience.validations.duration')) if duration.nil? || duration < 0
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
#  current      :boolean(1)      default(FALSE)
#

