class SkillCandidate < ActiveRecord::Base
  
  attr_accessible :level, :experience, :description, :skill_attributes
    
  belongs_to :skill
  belongs_to :candidate
  
  validates :candidate, :skill,                                                                                 :presence => true
  validates :description,        :length    => { :within => 20..160 },                                          :presence => true
  validates :level,              :inclusion => { :in => [ 'beginner', 'intermediate', 'advanced', 'expert' ] }, :presence => true, :if => :professional_skill?
  validates :experience,         :inclusion => { :in => (1..60).to_a },                                         :presence => true, :if => :professional_skill?
  validates :level, :experience, :length    => { :is => 0 },                                                                       :if => :interpersonal_skill?
  
  def professional_skill?
    skill.type == 'ProfessionalSkill'
  end
  
  def interpersonal_skill?
    skill.type == 'InterpersonalSkill'
  end
  
end

# == Schema Information
#
# Table name: skill_candidates
#
#  id           :integer(4)      not null, primary key
#  level        :string(255)
#  experience   :integer(4)
#  description  :string(255)
#  candidate_id :integer(4)
#  skill_id     :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

