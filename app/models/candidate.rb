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
    no_exp? ? nil : last_experience.end_year - first_experience.start_year - 1 + (13 - first_experience.start_month + last_experience.end_month) / 12.0
  end
  
  def longest_event
    if exp_and_edu? then longest [longest(educations), longest(experiences)] elsif no_exp_but_edu? then longest(educations) elsif no_edu_but_exp? then longest(experiences) else nil end
  end
  
  def longest(collection)
    collection.sort_by!{ |object| object.duration }.last
  end
  
  def first_event
    if exp_and_edu?
      [first_education, first_experience].sort_by!{ |event| if first_education.start_year == first_experience.start_year then event.start_month else event.start_year end }.first
    else
      if neither_exp_nor_edu? then nil elsif no_exp_but_edu? then first_education elsif no_edu_but_exp? then first_experience end
    end
  end
  
  def first_education
    educations.order("start_year ASC").order("start_month ASC").first
  end
  
  def first_experience
    experiences.order("start_year ASC").order("start_month ASC").first
  end
  
  def last_event
    if exp_and_edu?
      [last_education, last_experience].sort_by!{ |event| if last_education.end_year == last_experience.end_year then event.end_month else event.end_year end }.last
    else
      if neither_exp_nor_edu? then nil elsif no_exp_but_edu? then last_education elsif no_edu_but_exp? then last_experience end
    end
  end
  
  def last_education
    educations.order("end_year ASC").order("end_month ASC").last
  end
  
  def last_experience
    experiences.order("end_year ASC").order("end_month ASC").last
  end
  
  def no_exp?
    experiences.empty?
  end
  
  def no_edu?
    educations.empty?
  end
  
  def neither_exp_nor_edu?
    educations.empty? && experiences.empty?
  end
    
  def no_edu_but_exp?
    educations.empty? && !experiences.empty?
  end
    
  def no_exp_but_edu?
    experiences.empty? && !educations.empty?
  end
    
  def exp_and_edu?
    !experiences.empty? && !educations.empty?
  end
  
  def no_pro_skill?
    professional_skills.empty?
  end
  
  def no_perso_skill?
    interpersonal_skills.empty?
  end
  
  def no_certif?
    certificates.empty?
  end
  
  def no_lang?
    languages.empty?
  end
  
  def no_social?
    facebook_login.empty? && linkedin_login.empty && twitter_login.empty?
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

