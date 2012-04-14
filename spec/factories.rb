Factory.define :user do |user|
  user.first_name 'John'
  user.last_name 'Doe' 
  user.city 'Rotterdam'         
  user.country 'Netherlands'     
  user.nationality 'Netherlands'
  user.year_of_birth 1975
  user.phone '+31 6 00000000'
  user.email 'j.doe@example.com'
  user.facebook_login 'j.doe@example.com'
  user.linkedin_login 'j.doe@example.com'
  user.twitter_login '@john_d'
  user.password '45Georges?'
  user.password_confirmation '45Georges?'
end

Factory.define :candidate do |candidate|
  candidate.first_name 'John'
  candidate.last_name 'Doe' 
  candidate.city 'Rotterdam'         
  candidate.country 'Netherlands'     
  candidate.nationality 'Netherlands'
  candidate.year_of_birth 1975
  candidate.phone '+31 6 00000000'
  candidate.email { Factory.next(:email) }
  candidate.facebook_login { Factory.next(:facebook_login) }
  candidate.linkedin_login { Factory.next(:linkedin_login) }
  candidate.twitter_login { Factory.next(:twitter_login) }
  candidate.password '45Georges?'
  candidate.password_confirmation '45Georges?'
  candidate.status 'available'
end

Factory.define :recruiter do |recruiter|
  recruiter.first_name 'John'
  recruiter.last_name 'Doe' 
  recruiter.city 'Rotterdam'         
  recruiter.country 'Netherlands'     
  recruiter.nationality 'Netherlands'
  recruiter.year_of_birth 1975
  recruiter.phone '+31 6 00000000'
  recruiter.email { Factory.next(:email) }
  recruiter.facebook_login { Factory.next(:facebook_login) }
  recruiter.linkedin_login { Factory.next(:linkedin_login) }
  recruiter.twitter_login { Factory.next(:twitter_login) }
  recruiter.password '54John!'
  recruiter.password_confirmation '54John!'
  recruiter.quote "I am a technology recruiter specialized in find developers for Web companies. I don't really believe in profile matching, just contact me and we'll see what we can do ;)"
  recruiter.association :company
end

Factory.define :company do |company|
  company.name 'FFF'
  company.address 'John Macey lane'
  company.city 'London'
  company.country 'United Kingdom'
  company.phone '+44 7 987654321'
  company.email { Factory.next(:email) }
  company.url 'http://www.fff.co.uk'
  company.recruiter_agency false
end

Factory.define :experience do |experience|
  experience.role 'Sales manager'
  experience.start_month 6
  experience.start_year 1999
  experience.end_month 12
  experience.end_year 2004
  experience.description 'Business development, managing the sales team to reach targets, etc.'
  experience.association :candidate
  experience.association :company
end

Factory.define :degree_type do |degreetype|
  degreetype.label 'Master'  
end

Factory.define :degree do |degree|
  degree.label 'Biotechnology'
  degree.association :degree_type
end

Factory.define :school do |school|
  school.name 'Polyfarce Savoie'
  school.city 'Annecy'
  school.country 'France'
end

Factory.define :education do |education|
  education.description 'Parties during 3 years and tried to learn a few things...'
  education.start_month 9
  education.start_year  2005
  education.end_month 6
  education.end_year 2008
  education.association :degree
  education.association :school
  education.association :candidate
end

Factory.define :language do |language|
  language.label 'Spanish'
end

Factory.define :language_candidate do |language_candidate|
  language_candidate.level 'beginner'
  language_candidate.association :language
  language_candidate.association :candidate
end

Factory.define :skill do |skill|
  skill.label 'Sample skill'
end

Factory.define :interpersonal_skill do |interpersonal_skill|
  interpersonal_skill.label 'Sample interpersonal skill'
end

Factory.define :professional_skill do |professional_skill|
  professional_skill.label 'Sample professional skill'
end

Factory.define :interpersonal_skill_candidate do |interpersonal_skill_candidate|
  interpersonal_skill_candidate.description "I'm learning more and more everyday, I do intend to master this skill"
  interpersonal_skill_candidate.association :interpersonal_skill
  interpersonal_skill_candidate.association :candidate
end

Factory.define :professional_skill_candidate do |professional_skill_candidate|
  professional_skill_candidate.description "I'm on the way to be expert on this skill"
  professional_skill_candidate.level 'advanced'
  professional_skill_candidate.experience '4'
  professional_skill_candidate.association :professional_skill
  professional_skill_candidate.association :candidate
end

Factory.define :certificate do |certificate|
  certificate.label 'TOEFL'
end

Factory.define :certificate_candidate do |certificate_candidate|
  certificate_candidate.level_score 'B2'
  certificate_candidate.association :certificate
  certificate_candidate.association :candidate
end

Factory.define :message do |message|
  message.content 'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores'
  message.read false
  message.archived_author false
  message.archived_recipient false
  message.association :author
  message.association :recipient
end

Factory.sequence :email do |n|
  "user_#{n}@example.com"
end

Factory.sequence :facebook_login do |n|
  "user_#{n}@facebook.com"
end

Factory.sequence :linkedin_login do |n|
  "user_#{n}@linkedin.com"
end

Factory.sequence :twitter_login do |n|
  "@user_#{n}"
end