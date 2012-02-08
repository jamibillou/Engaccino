class Education < ActiveRecord::Base
  
  attr_accessible :description, :start_year, :end_year, :start_month, :end_month, :school_attributes, :degree_attributes, :degree_type_attributes
  
  belongs_to :candidate
  belongs_to :degree
  belongs_to :school
  
  accepts_nested_attributes_for :school, :reject_if => lambda { |attr| attr['name'].blank? },  :allow_destroy => true
  accepts_nested_attributes_for :degree, :reject_if => lambda { |attr| attr['label'].blank? }, :allow_destroy => true
  
  validates :candidate_id,                                              :presence => true
  validates :degree,                                                    :presence => true
  validates :school,                                                    :presence => true
  validates :start_year,  :inclusion => { :in => 1900..Time.now.year }, :presence => true
  validates :end_year,    :inclusion => { :in => 1900..Time.now.year }, :presence => true
  validates :start_month, :inclusion => { :in => 1..12 },               :presence => true
  validates :end_month,   :inclusion => { :in => 1..12 },               :presence => true
  validates :description, :length    => { :within => 20..300 },         :allow_blank => true
  
  validate  :date_consistance
  
#  def degreeType
#    DegreeType.find(degree.degree_type_id).label
#  end
  
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
      errors.add(:duration, I18n.t('education.validations.duration')) if duration.nil? || duration < 0
    end 
end

# == Schema Information
#
# Table name: educations
#
#  id           :integer(4)      not null, primary key
#  degree_id    :integer(4)
#  school_id    :integer(4)
#  candidate_id :integer(4)
#  description  :string(255)
#  start_month  :integer(4)
#  start_year   :integer(4)
#  end_month    :integer(4)
#  end_year     :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

