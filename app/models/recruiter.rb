class Recruiter < User
  
  attr_accessible :quote, :company_attributes
  
  belongs_to :company
  
  accepts_nested_attributes_for :company, :reject_if => lambda { |attr| attr['name'].blank? &&  attr['url'].blank? && attr['city'].blank? && attr['country'].blank?  }
  
  validates :quote, :length => { :maximum => 200 }
end
