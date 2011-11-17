Factory.define :user do |user|
  user.first_name "John"
  user.middle_name ""
  user.last_name "Doe" 
  user.city "Rotterdam"         
  user.country "Netherlands (The)"      
  user.nationality "A-marrocan"
  user.birthdate 40.years.ago
  user.phone "+31 6 00000000"
  user.email "j.doe@example.com"
  user.facebook_login "j.doe@example.com"
  user.linkedin_login "j.doe@example.com"
  user.twitter_login "@john_d"
end

Factory.sequence :email do |n|
  "user_#{n}@example.com"
end