class Candidate < User
  
  attr_accessible :status, :experiences_attributes, :educations_attributes, :degrees_attributes, :language_candidates_attributes
  
  has_many :experiences,          :dependent => :destroy
  has_many :companies,            :through   => :experiences

  has_many :educations,           :dependent => :destroy
  has_many :degrees,              :through   => :educations
  has_many :schools,              :through   => :educations
  
  has_many :language_candidates,  :dependent => :destroy
  has_many :language,             :through   => :language_candidates
  
  accepts_nested_attributes_for :experiences,
                                :reject_if => lambda { |attr| attr['company_attributes']['name'].blank? && attr['role'].blank? && attr['start_year'].blank? && attr['end_year'].blank? },
                                :allow_destroy => true
  accepts_nested_attributes_for :educations,            :reject_if => lambda { |attr| attr['year'].blank? }, :allow_destroy => true  
  accepts_nested_attributes_for :degrees,               :allow_destroy => true
  accepts_nested_attributes_for :language_candidates,   :allow_destroy => true
  
  status_array = [ 'available', 'looking', 'open', 'listening', 'happy' ]
  validates :status, :inclusion => { :in => status_array }, :presence => true
  
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
#  facebook_connect   :boolean(1)      default(FALSE)
#  linkedin_connect   :boolean(1)      default(FALSE)
#  twitter_connect    :boolean(1)      default(FALSE)
#  profile_completion :integer(4)      default(0)
#  admin              :boolean(1)      default(FALSE)
#  salt               :string(255)
#  encrypted_password :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  status             :string(255)
#  type               :string(255)
#

