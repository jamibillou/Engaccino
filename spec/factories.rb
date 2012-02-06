Factory.define :user do |user|
  user.first_name "John"
  user.last_name "Doe" 
  user.city "Rotterdam"         
  user.country "Netherlands"     
  user.nationality "Netherlands"
  user.year_of_birth 1975
  user.phone "+31 6 00000000"
  user.email "j.doe@example.com"
  user.facebook_login "j.doe@example.com"
  user.linkedin_login "j.doe@example.com"
  user.twitter_login "@john_d"
  user.password "45Georges?"
  user.password_confirmation "45Georges?"
end

Factory.define :candidate do |candidate|
  candidate.first_name "John"
  candidate.last_name "Doe" 
  candidate.city "Rotterdam"         
  candidate.country "Netherlands"     
  candidate.nationality "Netherlands"
  candidate.year_of_birth 1975
  candidate.phone "+31 6 00000000"
  candidate.email { Factory.next(:email) }
  candidate.facebook_login { Factory.next(:facebook_login) }
  candidate.linkedin_login { Factory.next(:linkedin_login) }
  candidate.twitter_login { Factory.next(:twitter_login) }
  candidate.password "45Georges?"
  candidate.password_confirmation "45Georges?"
  candidate.status "available"  
end

Factory.define :company do |company|
  company.name 'FFF'
  company.address 'John Macey lane'
  company.city 'London'
  company.country 'United Kingdom'
  company.phone '+44 7 987654321'
  company.email 'contact@fff.co.uk'
  company.url 'http://www.fff.co.uk'
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
  language_candidate.level :beginner
  language_candidate.association :language
  language_candidate.association :candidate
end

Factory.define :skill do |skill|
  skill.label 'Sample skill'
end

Factory.define :skill_perso do |skill_perso|
  skill_perso.label 'Sample skill perso'
end

Factory.define :skill_pro do |skill_pro|
  skill_pro.label 'Sample skill pro'
end

Factory.define :skill_candidate do |skill_candidate|
  skill_candidate.description "I'm learning more and more everyday, I do intend to master this skill"
  skill_candidate.level 'Intermediate'
  skill_candidate.experience '5'
  skill_candidate.association :skill
  skill_candidate.association :candidate
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