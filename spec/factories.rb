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
  candidate.email "j.doe@example.com"
  candidate.facebook_login "j.doe@example.com"
  candidate.linkedin_login "j.doe@example.com"
  candidate.twitter_login "@john_d"
  candidate.password "45Georges?"
  candidate.password_confirmation "45Georges?"
  candidate.status "available"  
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