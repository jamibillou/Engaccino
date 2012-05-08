class Education < ActiveRecord::Base
  
  attr_accessor   :main
  
  attr_accessible :description, :start_year, :end_year, :start_month, :end_month, :school_attributes, :degree_attributes, :degree_type_attributes, :main
  
  belongs_to :candidate
  belongs_to :degree
  belongs_to :school
  
  accepts_nested_attributes_for :school, :allow_destroy => true
  accepts_nested_attributes_for :degree, :allow_destroy => true
  
  validates :candidate_id,                                                            :presence => true
  validates :degree,                                                                  :presence => true
  validates :school,                                                                  :presence => true
  validates :start_year,  :inclusion => { :in => 100.years.ago.year..Time.now.year }, :presence => true
  validates :end_year,    :inclusion => { :in => 100.years.ago.year..Time.now.year }, :presence => true
  validates :start_month, :inclusion => { :in => 1..12 },                             :presence => true
  validates :end_month,   :inclusion => { :in => 1..12 },                             :presence => true
  validates :description, :length    => { :within => 20..300 },                       :allow_blank => true
  
  validate  :date_consistance, :unless => lambda { |proc| duration.nil? }
  
  def duration
    end_year - start_year - 1 + (13 - start_month + end_month) / 12.0 unless end_year.to_s.empty? || start_year.to_s.empty? || start_month.to_s.empty? || end_month.to_s.empty?
  end
  
  def yrs_after_first_event
    (self == candidate.first_event ? 0 : start_year - candidate.first_event.start_year - 1 + (12 - candidate.first_event.start_month + start_month) / 12.0) unless candidate.neither_exp_nor_edu?
  end
  
  private
  
    def date_consistance
      errors.add :duration, I18n.t('education.validations.duration') if duration < 0
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

