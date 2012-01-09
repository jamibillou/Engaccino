class Education < ActiveRecord::Base
  
  attr_accessible :description, :year, :school_attributes, :degree_attributes
  
  belongs_to :degree
  belongs_to :school
  belongs_to :candidate
  
  accepts_nested_attributes_for :school, :allow_destroy => true
  accepts_nested_attributes_for :degree, :allow_destroy => true
    
  validates :degree_id,                                                 :presence => true
  validates :school_id,                                                 :presence => true
  validates :candidate_id,                                              :presence => true
  validates :description, :length => { :within => 5..500 },             :allow_blank => true
  validates :year,        :inclusion => { :in => 1900..Time.now.year }, :allow_blank => true
  
  def degreeType
    DegreeType.find(degree.degree_type_id).label
  end
  
end
# == Schema Information
#
# Table name: educations
#
#  id           :integer(4)      not null, primary key
#  degree_id    :integer(4)
#  school_id    :integer(4)
#  candidate_id :integer(4)
#  description  :string(255)
#  year         :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

