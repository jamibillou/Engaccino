class Recruiter < User
  
  attr_accessible :quote, :company_attributes
  
  belongs_to :company
  
  accepts_nested_attributes_for :company
  
  validates :quote, :length => { :maximum => 200 }
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
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  image              :string(255)
#  main_education     :integer(4)
#  main_experience    :integer(4)
#  quote              :string(255)
#  company_id         :integer(4)
#

