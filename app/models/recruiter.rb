class Recruiter < User
  
  attr_accessible :quote, :company_attributes
  
  belongs_to :company
  
  accepts_nested_attributes_for :company
  
  validates :quote, :length => { :maximum => 200 }
end
