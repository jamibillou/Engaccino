class Candidate < User
  
  attr_accessible :status
  
  has_many :experiences, :dependent => :destroy
  has_many :companies,   :through   => :experiences
  
  accepts_nested_attributes_for :experiences, :reject_if => lambda { |attr| attr[:content].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :companies,   :reject_if => lambda { |attr| attr[:content].blank? }, :allow_destroy => true
  
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

