class Candidate < User
    
  attr_accessible :status, :experiences_attributes, :educations_attributes, :degrees_attributes, :languages_attributes, 
                  :professional_skills_attributes, :interpersonal_skills_attributes, :main_education, :main_experience
  
  has_many :experiences,                    :dependent => :destroy
  has_many :companies,                      :through   => :experiences
  has_many :educations,                     :dependent => :destroy
  has_many :degrees,                        :through   => :educations
  has_many :schools,                        :through   => :educations
  has_many :language_candidates,            :dependent => :destroy
  has_many :languages,                      :through   => :language_candidates
  has_many :certificate_candidates,         :dependent => :destroy
  has_many :certificates,                   :through   => :certificate_candidates
  has_many :professional_skill_candidates,  :dependent => :destroy
  has_many :professional_skills,            :through   => :professional_skill_candidates
  has_many :interpersonal_skill_candidates, :dependent => :destroy
  has_many :interpersonal_skills,           :through   => :interpersonal_skill_candidates
  
  accepts_nested_attributes_for :experiences,
                                :reject_if => lambda { |attr| attr['company_attributes']['name'].blank? && attr['role'].blank? && attr['start_year'].blank? && attr['end_year'].blank? },
                                :allow_destroy => true
  accepts_nested_attributes_for :educations,
                                :reject_if => lambda { |attr| attr['school_attributes']['label'].blank? &&
                                                              attr['degree_attributes']['label'].blank? && 
                                                              attr['degree_attributes']['degree_type_attributes']['label'].blank? && 
                                                              attr['start_year'].blank? && attr['end_year'].blank? }, 
                                :allow_destroy => true  
  accepts_nested_attributes_for :degrees,                 :allow_destroy => true
  accepts_nested_attributes_for :language_candidates,     :allow_destroy => true
  accepts_nested_attributes_for :certificate_candidates,  :allow_destroy => true
  
  validates :status, :inclusion => { :in => [ 'available', 'looking', 'open', 'listening', 'happy' ] }, :presence => true
    
  def timeline_duration
    last_event.nil? && first_event.nil? ? nil : last_event.end_year - first_event.start_year - 1 + (13 - first_event.start_month + last_event.end_month) / 12.0
  end
  
  def experience_duration
    experiences.empty? ? nil : last(experiences).end_year - first(experiences).start_year - 1 + (13 - first(experiences).start_month + last(experiences).end_month) / 12.0
  end
  
  def long_timeline?
    timeline_duration.nil? ? nil : timeline_duration > 20
  end
  
  def longest_event
    if educations.empty? && experiences.empty?
      nil
    elsif !educations.empty? && experiences.empty?
      longest(educations)
    elsif educations.empty? && !experiences.empty?
      longest(experiences)
    else
      longest [longest(educations), longest(experiences)]
    end
  end
  
  def first_event
    if educations.empty? && experiences.empty?
      nil
    elsif !educations.empty? && experiences.empty?
      first(educations)
    elsif educations.empty? && !experiences.empty?
      first(experiences)
    else
      [first(educations), first(experiences)].sort_by!{ |event| if first(educations).start_year == first(experiences).start_year then event.start_month else event.start_year end }.first
    end
  end
  
  def last_event
    if educations.empty? && experiences.empty?
      nil
    elsif !educations.empty? && experiences.empty?
      last(educations)
    elseif educations.empty? && !experiences.empty?
      last(experiences)
    else
      [last(educations), last(experiences)].sort_by!{ |event| if last(educations).end_year == last(experiences).end_year then event.end_month else event.end_year end }.last
    end
  end
  
  def longest(collection)
    collection.sort_by!{ |object| object.duration }.last
  end
  
  def first(collection)
    collection.order("start_year ASC").order("start_month ASC").first
  end
  
  def last(collection)
    collection.order("end_year ASC").order("end_month ASC").last
  end
  
end

# == Schema Information
#
# Table name: users
#
#  id                 :integer(4)      not null, primary key
#  first_name         :string(255)
#  last_name          :string(255)
#  city               :string(255)
#  country            :string(255)
#  nationality        :string(255)
#  year_of_birth      :integer(4)
#  phone              :string(255)
#  email              :string(255)
#  facebook_login     :string(255)
#  linkedin_login     :string(255)
#  twitter_login      :string(255)
#  status             :string(255)
#  type               :string(255)
#  facebook_connect   :boolean(1)      default(FALSE)
#  linkedin_connect   :boolean(1)      default(FALSE)
#  twitter_connect    :boolean(1)      default(FALSE)
#  profile_completion :integer(4)      default(0)
#  admin              :boolean(1)      default(FALSE)
#  salt               :string(255)
#  encrypted_password :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  image              :string(255)
#  main_education     :integer(4)
#  main_experience    :integer(4)
#

