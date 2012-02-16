class CertificateCandidate < ActiveRecord::Base
  
  attr_accessible :description, :certificate_attributes, :certificate
    
  belongs_to :certificate
  belongs_to :candidate
  
  accepts_nested_attributes_for :certificate, :allow_destroy => true
  
  validates :candidate, :certificate,                                           :presence => true
  validates :description,        :length    => { :within => 20..160 },            :presence => true  
end
