class User < ActiveRecord::Base

  attr_accessible :first_name,
                  :middle_name,
                  :last_name,
                  :city,
                  :country,
                  :nationality,
                  :birthdate,
                  :phone,
                  :email,
                  :facebook_login,
                  :linkedin_login,
                  :twitter_login
  
  email_regex = /\A[\w+\d\-.]+@[a-z\d\-.]+\.[a-z.]+\z/i
                 
  validates :first_name, :presence => true,
                         :length => { :maximum => 80 }
  validates :middle_name,:length => { :maximum => 80 }
  validates :last_name,  :presence => true,
                         :length => { :maximum => 80 }
  validates :email,      :presence => true,
                         :format => { :with => email_regex },
                         :uniqueness => { :case_sensitive => false } 
  validates :country,    :presence => true,
                         :if => :valid_country?                              
  
  def valid_country?
    #Country.new(self.country).valid?
    false
  end                     
end

# == Schema Information
#
# Table name: users
#
#  id                 :integer(4)      not null, primary key
#  first_name         :string(255)
#  middle_name        :string(255)
#  last_name          :string(255)
#  city               :string(255)
#  country            :string(255)
#  nationality        :string(255)
#  birthdate          :date
#  phone              :string(255)
#  email              :string(255)
#  facebook_login     :string(255)
#  linkedin_login     :string(255)
#  twitter_login      :string(255)
#  facebook_connect   :boolean(1)
#  linkedin_connect   :boolean(1)
#  twitter_connect    :boolean(1)
#  admin              :boolean(1)      default(FALSE)
#  encrypted_password :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

