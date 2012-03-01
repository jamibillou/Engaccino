class CertificateCandidate < ActiveRecord::Base
  
  attr_accessible :level_score, :certificate_attributes, :certificate
    
  belongs_to :certificate
  belongs_to :candidate
  
  accepts_nested_attributes_for :certificate, :allow_destroy => true
  
  validates :candidate, :certificate,                                  :presence => true
  validates :level_score,             :length => { :within => 0..20 }, :allow_blank => true  
  
end

# == Schema Information
#
# Table name: certificate_candidates
#
#  id             :integer(4)      not null, primary key
#  level_score    :string(255)
#  candidate_id   :integer(4)
#  certificate_id :integer(4)
#  created_at     :datetime
#  updated_at     :datetime
#

