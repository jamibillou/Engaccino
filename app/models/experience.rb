class Experience < ActiveRecord::Base

  attr_accessor   :main
  
  attr_accessible :role, :start_month, :start_year, :end_month, :end_year, :description, :company_attributes, :company, :current, :main
  
  belongs_to :candidate
  belongs_to :company
  
  accepts_nested_attributes_for :company, :allow_destroy => true
  
  before_validation :set_current_date 
            
  validates :candidate_id,                                              :presence => true
  validates :company,                                                   :presence => true
  validates :role,        :length    => { :within => 3..80 },           :presence => true
  validates :start_month, :inclusion => { :in => 1..12 },               :presence => true
  validates :start_year,  :inclusion => { :in => 1900..Time.now.year }, :presence => true
  validates :end_month,   :inclusion => { :in => 1..12 },               :presence => true
  validates :end_year,    :inclusion => { :in => 1900..Time.now.year }, :presence => true
  validate  :date_consistance
  validates :description, :length    => { :within => 20..300 },         :allow_blank => true
  
  after_update      :set_main
  after_create      :set_main
  after_destroy     :set_main
  
  def duration
    (end_year.to_s.empty? || start_year.to_s.empty? || start_month.to_s.empty? || end_month.to_s.empty?) ? -1 : (end_year - start_year - 1 + (13 - start_month + end_month) / 12.0)      
  end
  
  def yrs_after_first_event
    (self == candidate.first_event ? 0 : start_year - candidate.first_event.start_year - 1 + (12 - candidate.first_event.start_month + start_month) / 12.0) unless candidate.neither_exp_nor_edu?
  end
  
  private
    
    def date_consistance
      errors.add(:duration, I18n.t('experience.validations.duration')) if duration < 0
    end
    
    def set_current_date
      (self.end_month = Time.now.month ; self.end_year = Time.now.year) if current?
    end
    
    def set_main
      candidate.update_attributes :main_experience => candidate.last_experience.id unless candidate.last_experience.nil? || candidate.main_experience == candidate.last_experience.id
    end
    
    def update_completion_new
      candidate.update_attributes :profile_completion => candidate.profile_completion + 5 if candidate.experiences.count < 4
    end
  
    def update_completion_del
      candidate.update_attributes :profile_completion => candidate.profile_completion - 5 if candidate.experiences.count < 3
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

