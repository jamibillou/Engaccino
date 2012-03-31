class User < ActiveRecord::Base

  attr_accessor   :password
  
  attr_accessible :first_name, :last_name, :city, :country, :nationality, :year_of_birth, :phone, :email, :facebook_login,
                  :linkedin_login, :twitter_login, :profile_completion, :password, :password_confirmation, :image
  
  has_many :authored_messages,                                  :class_name => 'Message', :foreign_key => 'author_id'
  has_many :received_messages,                                  :class_name => 'Message', :foreign_key => 'recipient_id'
  has_many :message_authors,    :through => :received_messages, :class_name => 'User',    :source => 'author'
  has_many :message_recipients, :through => :authored_messages, :class_name => 'User',    :source => 'recipient'
  
  countries_array = Country.all.collect { |c| c[0] }
    
  validates :email,                      :email_format => true,                 :uniqueness => { :case_sensitive => false },     :presence => true
  validates :password,                   :on => :create, :confirmation => true, :length => { :within => 6..40 },                 :presence => true
  validates :first_name, :last_name,     :length => { :maximum => 80 },                                                          :presence => true
  validates :country,                    :inclusion => { :in => countries_array },                                               :presence => true
  validates :city,                                                                                                               :presence => true
  validates :nationality,                :inclusion => { :in => countries_array },                                               :allow_blank => true
  validates :year_of_birth,              :inclusion => { :in => 100.years.ago.year..Time.now.year },                             :allow_blank => true
  validates :phone,                      :phone_format => true,                 :length => { :within => 7..20 },                 :allow_blank => true     
  validates :facebook_login,             :email_format => true,                 :uniqueness => { :case_sensitive => false },     :allow_blank => true
  validates :linkedin_login,             :email_format => true,                 :uniqueness => { :case_sensitive => false },     :allow_blank => true
  validates :twitter_login,              :twitter_format => true,               :uniqueness => { :case_sensitive => false },     :allow_blank => true
  validates :profile_completion,         :inclusion => { :in => 0..100 }
                                                                  
  before_create  :encrypt_password
  
  mount_uploader :image, UserImageUploader
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def candidate?
    self.class.name.downcase == 'candidate'
  end
  
  def recruiter?
    self.class.name.downcase == 'recruiter'
  end
  
  def admin?
    self.admin
  end
  
  class << self
  
    def authenticate(email, submitted_password)
      user = find_by_email email
      (user && user.has_password?(submitted_password)) ? user : nil
    end
    
    def authenticate_with_salt(id, cookie_salt)
      user = find_by_id id
      (user && user.salt == cookie_salt) ? user : nil
    end
  end
  
  private 
  
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt password
    end
    
    def encrypt(string)
      secure_hash "#{salt} -- #{string}"
    end
    
    def make_salt
      secure_hash "#{Time.now.utc} -- #{password}"
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest string
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
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  image              :string(255)
#  main_education     :integer(4)
#  main_experience    :integer(4)
#  quote              :string(255)
#  company_id         :integer(4)
#

