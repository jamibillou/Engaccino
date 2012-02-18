class CertificateCandidate < ActiveRecord::Base
  
  attr_accessible :description, :certificate_attributes, :certificate
    
  belongs_to :certificate
  belongs_to :candidate
  
  accepts_nested_attributes_for :certificate, :allow_destroy => true
  
  validates :candidate, :certificate,                                           :presence => true
  validates :description,        :length    => { :within => 20..160 },            :presence => true  
end
# == Schema Information
#
# Table name: certificate_candidates
#
#  id             :integer(4)      not null, primary key
#  description    :string(255)
#  candidate_id   :integer(4)
#  certificate_id :integer(4)
#  created_at     :datetime
#  updated_at     :datetime
#

