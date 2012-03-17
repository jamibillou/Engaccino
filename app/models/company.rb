class Company < ActiveRecord::Base

  attr_accessible :name, :address, :zip, :city, :country, :phone, :email, :url, :image, :about
  
  has_many :experiences, :dependent => :destroy
  has_many :candidates,  :through => :experiences
  has_many :recruiters
  
  countries_array = Country.all.collect { |c| c[0] }
  
  validates :name,    :length       => { :maximum => 80 },                                :presence    => true
  validates :city,    :length       => { :maximum =>  80 },                               :presence    => true
  validates :country, :inclusion    => { :in => countries_array },                        :presence    => true
  validates :address, :length       => { :maximum => 160 },                               :allow_blank => true
  validates :about,   :length       => { :within => 20..160 },                            :allow_blank => true
  validates :url,     :url_format   => true,                                              :allow_blank => true
  validates :email,   :email_format => true, :uniqueness => { :case_sensitive => false }, :allow_blank => true
  validates :phone,   :phone_format => true, :length     => { :within => 7..20 },         :allow_blank => true
  validates :zip,     :length       => { :maximum =>  10 },                               :allow_blank => true
  
  mount_uploader :image, CompanyImageUploader
    
  def no_about?
    about.nil? || about.empty?
  end
  
  def no_contact_info?
    (url.nil? || url.empty?) && (email.nil? || email.empty?) && (phone.nil? || phone.empty?)
  end
end

# == Schema Information
#
# Table name: companies
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  address    :string(255)
#  city       :string(255)
#  country    :string(255)
#  phone      :string(255)
#  email      :string(255)
#  url        :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  image      :string(255)
#  zip        :string(255)
#  about      :string(255)
#  latitude   :float
#  longitude  :float
#  gmaps      :boolean(1)
#

