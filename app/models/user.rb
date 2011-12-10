class User < ActiveRecord::Base

  attr_accessor :password
  
  attr_accessible :first_name, :last_name,
                  :city, :country,
                  :nationality, :year_of_birth,
                  :phone, :email,
                  :facebook_login, :linkedin_login, :twitter_login,
                  :password, :password_confirmation,
                  :profile_completion
  
  countries_array = Country.all.collect { |c| c[0] }
  email_regex = /^[\w+\d\-.]+@[a-z\d\-.]+\.[a-z]{2,3}(\.[a-z]{2,3})?$/i
  phone_regex = /^\+(?:[0-9] ?){6,14}[0-9]$/
  twitter_regex = /^@(_|([a-z]_)|[a-z])([a-z0-9]+_?)*$/i
  
  validates_presence_of             :email, :first_name, :last_name
  validates_presence_of             :password, :on => :create
    
  validates :first_name,            :length => { :maximum => 80 }
                            
  validates :last_name,             :length => { :maximum => 80 }
                                      
  validates :country,               :inclusion => { :in => countries_array },
                                    :allow_blank => true
                                    
  validates :nationality,           :inclusion => { :in => countries_array },
                                    :allow_blank => true
                                    
  validates :year_of_birth,         :inclusion => { :in => 1900..Time.now.year },
                                    :allow_blank => true  
                                    
  validates :phone,                 :length => { :minimum => 7, :maximum => 20 },
                                    :format => { :with => phone_regex },
                                    :allow_blank => true       
                                                  
  validates :email,                 :format => { :with => email_regex },
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
                                    
  validates :password,              :confirmation => true,
  					                        :length => { :within => 6..40 },
  					                        :on => :create
  					                        
  validates :profile_completion,    :inclusion => { :in => 0..100 }
  
  before_save :encrypt_password
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  class << self
  
    def authenticate(email, submitted_password)
      user = find_by_email(email)
      (user && user.has_password?(submitted_password)) ? user : nil
    end
    
    def authenticate_with_salt(id, cookie_salt)
      user = find_by_id(id)
      (user && user.salt == cookie_salt) ? user : nil
    end
  end
  
  private 
  
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password) unless !new_record? || password.blank?
    end
    
    def encrypt(string)
      secure_hash("#{salt} -- #{string}")
    end
    
    def make_salt
      secure_hash("#{Time.now.utc} -- #{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
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
#  facebook_connect   :boolean(1)      default(FALSE)
#  linkedin_connect   :boolean(1)      default(FALSE)
#  twitter_connect    :boolean(1)      default(FALSE)
#  admin              :boolean(1)      default(FALSE)
#  encrypted_password :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  salt               :string(255)
#  year_of_birth      :integer(4)
#  profile_completion :integer(4)      default(0)
#

