class LanguageCandidate < ActiveRecord::Base
  
  attr_accessible :level, :language_attributes
  
  belongs_to :language
  belongs_to :candidate
  
  accepts_nested_attributes_for :language,  :allow_destroy => true

  validates :candidate, :language,                                                                              :presence => true
  validates :level,                :inclusion => { :in => [ 'beginner', 'intermediate', 'fluent', 'native' ] }, :presence => true
  
  after_create   :update_completion_new
  after_destroy  :update_completion_del
  
  private
  
    def update_completion_new
      candidate.update_attributes :profile_completion => candidate.profile_completion+10 if candidate.language_candidates.count < 2
    end
    
    def update_completion_del
      candidate.update_attributes :profile_completion => candidate.profile_completion-10 if candidate.language_candidates.empty?
    end
  
end

# == Schema Information
#
# Table name: language_candidates
#
#  id           :integer(4)      not null, primary key
#  language_id  :integer(4)
#  candidate_id :integer(4)
#  level        :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

