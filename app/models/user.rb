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
  
  countries_array = Country.all.collect { |c| c[1] }
  dates_array = (100.years.ago.to_date..11.years.ago.to_date).to_a
  email_regex = /^[\w+\d\-.]+@[a-z\d\-.]+\.[a-z.]+$/i
  phone_regex = /^\+(?:[0-9] ?){6,14}[0-9]$/
  twitter_regex = /^@(_|([a-z]_)|[a-z])([a-z0-9]+_?)*$/i

  validates :first_name,            :presence => true,
                                    :length => { :maximum => 80 }
                                    
  validates :middle_name,           :length => { :maximum => 80 },
                                    :allow_blank => true
                                    
  validates :last_name,             :presence => true,
                                    :length => { :maximum => 80 }
                                    
  validates :country,               :presence => true,
                                    :inclusion => { :in => countries_array }
                                    
  validates :nationality,           :inclusion => { :in => countries_array },
                                    :allow_blank => true
                                    
  validates :birthdate,             :presence => true,
                                    :inclusion => { :in => dates_array }
                                    
  validates :phone,                 :length => { :minimum => 7, :maximum => 20 },
                                    :format => { :with => phone_regex },
                                    :allow_blank => true       
                                                  
  validates :email,                 :presence => true,
                                    :format => { :with => email_regex },
                                    :uniqueness => { :case_sensitive => false } 
                                    
  validates :facebook_login,        :format => { :with => email_regex },
                                    :uniqueness => { :case_sensitive => false },
                                    :allow_blank => true
                                    
  validates :linkedin_login,        :format => { :with => email_regex },
                                    :uniqueness => { :case_sensitive => false },
                                    :allow_blank => true
                                    
  validates :twitter_login,         :format => { :with => twitter_regex },
                                    :uniqueness => { :case_sensitive => false },
                                    :allow_blank => true
                                                          
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

